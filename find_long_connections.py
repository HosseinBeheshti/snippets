import requests
import datetime
import time
import os
import json # Added for JSONDecodeError

# --- Configuration - PLEASE UPDATE THESE VALUES ---
# It's recommended to use environment variables for sensitive data.
# Example: export HIDDIFY_PANEL_URL="https://your.panel.com"
#          export HIDDIFY_ADMIN_SECRET="youradminsecretpath"

HIDDIFY_PANEL_URL = os.environ.get("HIDDIFY_PANEL_URL", "https://your-hiddify-domain.com") # Base URL of your Hiddify panel
ADMIN_SECRET_PATH = os.environ.get("HIDDIFY_ADMIN_SECRET", "your_admin_secret_path") # Your Hiddify Admin Panel secret path

# --- IMPORTANT: API Endpoint Assumption ---
# This is a HYPOTHETICAL API endpoint. You MUST find the correct one for your Hiddify version
# that provides a list of online users with their session start timestamps.
# It might be part of a general user status endpoint or a specific "online users" endpoint.
# Example: f"{HIDDIFY_PANEL_URL}/{ADMIN_SECRET_PATH}/api/v2/admin/users/online_status/"
API_ENDPOINT_ONLINE_USERS = f"{HIDDIFY_PANEL_URL}/{ADMIN_SECRET_PATH}/api/v2/admin/YOUR_API_ENDPOINT_HERE/"

SIX_HOURS_IN_SECONDS = 6 * 60 * 60

def get_online_users_from_hiddify_api():
    """
    Fetches online user data from the Hiddify API.
    This function is a TEMPLATE and likely needs modification.
    """
    headers = {
        "Accept": "application/json",
        # Add any other necessary headers if your Hiddify API requires them (e.g., API token)
    }

    print(f"Attempting to fetch data from: {API_ENDPOINT_ONLINE_USERS}")
    
    try:
        response = requests.get(API_ENDPOINT_ONLINE_USERS, headers=headers, timeout=20) # Increased timeout
        response.raise_for_status()  # Raises an HTTPError for bad responses (4XX or 5XX)
        
        data = response.json()
        
        # Adjust based on your API's response structure:
        if isinstance(data, list): # e.g. [ {user1}, {user2} ]
            return data
        elif isinstance(data, dict) and "data" in data and isinstance(data["data"], list): # e.g. { "data": [ {user1}, ... ] }
            return data["data"]
        elif isinstance(data, dict) and "users" in data and isinstance(data["users"], list): # e.g. { "users": [ {user1}, ... ] }
            return data["users"]
        else:
            print(f"Error: API response is not in a recognized list format. Response snippet: {str(data)[:200]}")
            return []

    except requests.exceptions.Timeout:
        print(f"Error: Request to Hiddify API timed out ({API_ENDPOINT_ONLINE_USERS}).")
        return []
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to Hiddify API: {e}")
        return []
    except json.JSONDecodeError:
        print(f"Error decoding JSON response from API. Response text: {response.text[:200]}...")
        return []

def get_mock_data_for_testing():
    """Returns mock data for testing if the API is not available or for development."""
    print("WARNING: Using MOCKED data. API call was bypassed or failed.")
    current_unix_time = time.time()
    return [
        {"uuid": "user-uuid-1", "username": "alice", "connected_since_timestamp": current_unix_time - (7 * 3600)},
        {"uuid": "user-uuid-2", "username": "bob",   "connected_since_timestamp": current_unix_time - (2 * 3600)},
        {"uuid": "user-uuid-3", "username": "charlie", "connected_since_timestamp": current_unix_time - (10 * 3600)},
        {"uuid": "user-uuid-4", "username": "dave",  "connected_since_timestamp": current_unix_time - (30 * 60)},
        {"uuid": "user-uuid-5", "username": "eve_no_timestamp"}, # User with missing timestamp
        {"uuid": "user-uuid-6", "username": "frank_bad_timestamp", "connected_since_timestamp": "not-a-valid-timestamp"},
    ]

def find_long_connections():
    # --- Control Flag ---
    # Set to True to use mock data for testing, False to attempt a live API call.
    USE_MOCK_DATA_ONLY = False 
    
    # Force mock data if default placeholders are still present
    if HIDDIFY_PANEL_URL == "https://your-hiddify-domain.com" or \
       ADMIN_SECRET_PATH == "your_admin_secret_path" or \
       API_ENDPOINT_ONLINE_USERS.endswith("/YOUR_API_ENDPOINT_HERE/"):
        print("\nWARNING: Default configuration placeholders detected.")
        print("Forcing MOCK data usage. Please update script configurations for live API calls.")
        USE_MOCK_DATA_ONLY = True

    if USE_MOCK_DATA_ONLY:
        online_users_data = get_mock_data_for_testing()
    else:
        online_users_data = get_online_users_from_hiddify_api()

    if not online_users_data:
        print("No online user data received or processed.")
        return

    long_connection_users = []
    current_time_unix = time.time()

    print(f"\nProcessing {len(online_users_data)} user entries...")

    for user_data in online_users_data:
        # --- Adjust these keys based on your Hiddify API response structure ---
        user_uuid = user_data.get("uuid")
        username = user_data.get("username", user_uuid) # Default to UUID if username is not present
        connected_since_ts = user_data.get("connected_since_timestamp") # CRITICAL FIELD

        if not user_uuid:
            print(f"Warning: Skipping entry with missing UUID: {str(user_data)[:100]}")
            continue
        
        if connected_since_ts is None:
            # This user might be offline or the API doesn't provide this info for them.
            # print(f"Info: User {username} (UUID: {user_uuid}) has no 'connected_since_timestamp'. Skipping duration check.")
            continue

        try:
            # Ensure timestamp is a number (float or int)
            connected_since_ts = float(connected_since_ts)
        except (ValueError, TypeError):
            print(f"Warning: Invalid 'connected_since_timestamp' format for user {username} (UUID: {user_uuid}): '{connected_since_ts}'. Skipping.")
            continue
            
        connection_duration_seconds = current_time_unix - connected_since_ts

        if connection_duration_seconds > SIX_HOURS_IN_SECONDS:
            duration_hours = connection_duration_seconds / 3600.0
            try:
                # Convert Unix timestamp to human-readable string
                connected_since_dt = datetime.datetime.fromtimestamp(connected_since_ts)
                # Format to include timezone information if possible, or denote UTC if that's what the timestamp is
                connected_since_str = connected_since_dt.strftime('%Y-%m-%d %H:%M:%S') # Add %Z for timezone name if available
            except Exception: 
                connected_since_str = "Invalid Timestamp for Display"

            long_connection_users.append({
                "username": username,
                "uuid": user_uuid,
                "duration_hours": round(duration_hours, 2),
                "connected_since_str": connected_since_str
            })

    if long_connection_users:
        print("\n--- Users Online for More Than 6 Hours ---")
        for user_info in long_connection_users:
            print(f"  User: {user_info['username']} (UUID: {user_info['uuid']})")
            print(f"    Connected Since: {user_info['connected_since_str']}")
            print(f"    Current Duration: ~{user_info['duration_hours']} hours")
            print("-" * 30)
    else:
        print("\nNo users currently found online for more than 6 hours based on the processed data.")

if __name__ == "__main__":
    print("Hiddify User Long Connection Finder")
    print("====================================")
    print("DISCLAIMER:")
    print("1. This script RELIES on your Hiddify API providing an endpoint that returns")
    print("   a list of currently online users, EACH with a 'connected_since_timestamp' (Unix timestamp).")
    print("2. You MUST update 'HIDDIFY_PANEL_URL', 'ADMIN_SECRET_PATH', and especially")
    print("   'API_ENDPOINT_ONLINE_USERS' with your Hiddify panel's specific details.")
    print("3. If your API's data structure for users or timestamps is different, you will need")
    print("   to modify the data parsing logic within the script.")
    print("4. For initial testing or if your API endpoint is unknown, you can set")
    print("   `USE_MOCK_DATA_ONLY = True` inside the `find_long_connections` function.")
    print("------------------------------------")
    
    find_long_connections()