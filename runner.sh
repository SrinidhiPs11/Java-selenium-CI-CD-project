#!/bin/bash

#-------------------------------------------------------------------
#  This script expects the following environment variables
#     HUB_HOST
#     BROWSER
#     THREAD_COUNT
#     TEST_SUITE
#-------------------------------------------------------------------

# Let's print what we have received
echo "-------------------------------------------"
echo "HUB_HOST      : ${HUB_HOST:-hub}"
echo "BROWSER       : ${BROWSER:-chrome}"
echo "THREAD_COUNT  : ${THREAD_COUNT:-1}"
echo "TEST_SUITE    : ${TEST_SUITE}"
echo "-------------------------------------------"

# Do not start the tests immediately. Hub has to be ready with browser nodes
echo "Checking if hub is ready..!"

count=0

# Wait for Selenium Hub to be ready
while true; do
    response=$(curl -s http://${HUB_HOST:-hub}:4444/status)
    
    # Check if curl failed
    if [ -z "$response" ]; then
        echo "Error: No response from Selenium Hub!"
        continue
    fi

    # Extract the "ready" value safely
    ready=$(echo "$response" | jq -r .value.ready 2>/dev/null)

    # Ensure "ready" is either "true" or "false" before using it
    if [ "$ready" == "true" ]; then
        echo "Selenium Hub is ready!"
        break
    fi

    count=$((count+1))
    echo "Attempt: ${count}"

    # Timeout after 6 attempts (30 seconds)
    if [ "$count" -ge 6 ]; then
        echo "**** HUB IS NOT READY WITHIN 30 SECONDS ****"
        exit 1
    fi

    sleep 5
done

# At this point, selenium grid should be up!
echo "Selenium Grid is up and running. Running the test...."

# Start the java command
java -cp 'libs/*' \
     -DseleniumGridEnabled=true \
     -DseleniumGridhubHost="${HUB_HOST:-hub}" \
     -Dbrowser="${BROWSER:-chrome}" \
     org.testng.TestNG \
     -threadcount "${THREAD_COUNT:-1}" \
     test-suites/"${TEST_SUITE}"