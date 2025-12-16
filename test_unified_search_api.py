#!/usr/bin/env python3
"""
Test script for the unified search API endpoint
Tests all three actions: search, track_click, and feedback
"""

import requests
import json
import sys

API_URL = "http://localhost:8000"

def print_section(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print('='*60)

def test_root_endpoint():
    """Test the root endpoint to see API documentation"""
    print_section("Testing Root Endpoint")
    try:
        response = requests.get(f"{API_URL}/")
        print(f"Status: {response.status_code}")
        print(json.dumps(response.json(), indent=2))
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_health_endpoint():
    """Test the health check endpoint"""
    print_section("Testing Health Endpoint")
    try:
        response = requests.get(f"{API_URL}/health")
        print(f"Status: {response.status_code}")
        print(json.dumps(response.json(), indent=2))
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_search_action():
    """Test the search action"""
    print_section("Testing Search Action")

    payload = {
        "action": "search",
        "query": "тормозные колодки",
        "limit": 5
    }

    try:
        response = requests.post(f"{API_URL}/search", json=payload)
        print(f"Status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"\n✅ Search successful!")
            print(f"Action: {data.get('action')}")
            print(f"Query: {data.get('query')}")
            print(f"Total Results: {data.get('total_results')}")
            print(f"Execution Time: {data.get('execution_time_ms')}ms")
            print(f"Search ID: {data.get('search_id')}")
            print(f"Results: {len(data.get('results', []))} products")

            if data.get('results'):
                print(f"\nFirst result:")
                print(f"  - Product ID: {data['results'][0].get('product_id')}")
                print(f"  - Name: {data['results'][0].get('name')}")
                print(f"  - Score: {data['results'][0].get('similarity_score')}")

            return data.get('search_id')
        else:
            print(f"❌ Error: {response.status_code}")
            print(response.text)
            return None

    except Exception as e:
        print(f"❌ Error: {e}")
        return None

def test_click_tracking_action(search_id):
    """Test the click tracking action"""
    print_section("Testing Click Tracking Action")

    if not search_id:
        print("⚠️  Skipping click tracking test (no search_id available)")
        return False

    payload = {
        "action": "track_click",
        "search_id": search_id,
        "clicked_product_id": 12345,
        "rank_position": 1
    }

    try:
        response = requests.post(f"{API_URL}/search", json=payload)
        print(f"Status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"\n✅ Click tracked successfully!")
            print(f"Action: {data.get('action')}")
            print(f"Success: {data.get('success')}")
            print(f"Message: {data.get('message')}")
            print(f"Click ID: {data.get('click_id')}")
            print(f"Execution Time: {data.get('execution_time_ms')}ms")
            return True
        else:
            print(f"❌ Error: {response.status_code}")
            print(response.text)
            return False

    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_feedback_action(search_id):
    """Test the feedback action"""
    print_section("Testing Feedback Action")

    if not search_id:
        print("⚠️  Skipping feedback test (no search_id available)")
        return False

    payload = {
        "action": "feedback",
        "search_id": search_id,
        "feedback_type": "helpful",
        "feedback_comment": "Great search results!"
    }

    try:
        response = requests.post(f"{API_URL}/search", json=payload)
        print(f"Status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"\n✅ Feedback submitted successfully!")
            print(f"Action: {data.get('action')}")
            print(f"Success: {data.get('success')}")
            print(f"Message: {data.get('message')}")
            print(f"Execution Time: {data.get('execution_time_ms')}ms")
            return True
        else:
            print(f"❌ Error: {response.status_code}")
            print(response.text)
            return False

    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_invalid_action():
    """Test with invalid action"""
    print_section("Testing Invalid Action (Error Handling)")

    payload = {
        "action": "invalid_action",
        "query": "test"
    }

    try:
        response = requests.post(f"{API_URL}/search", json=payload)
        print(f"Status: {response.status_code}")

        if response.status_code == 400:
            print(f"\n✅ Correctly rejected invalid action!")
            print(f"Error: {response.json().get('detail')}")
            return True
        else:
            print(f"❌ Expected 400 status, got {response.status_code}")
            return False

    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    """Run all tests"""
    print("\n" + "="*60)
    print("  UNIFIED SEARCH API TEST SUITE")
    print("="*60)

    # Test basic endpoints
    if not test_root_endpoint():
        print("\n⚠️  API might not be running. Please start the API first.")
        sys.exit(1)

    if not test_health_endpoint():
        print("\n⚠️  Health check failed. Check database connection.")

    # Test search action
    search_id = test_search_action()

    # Test click tracking action
    test_click_tracking_action(search_id)

    # Test feedback action
    test_feedback_action(search_id)

    # Test error handling
    test_invalid_action()

    print("\n" + "="*60)
    print("  TEST SUITE COMPLETE")
    print("="*60)
    print("\n✅ All tests completed! Check results above.")

if __name__ == "__main__":
    main()
