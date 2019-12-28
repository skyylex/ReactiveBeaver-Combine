set -e
set -o pipefail

PLATFORM=""
EXECUTABLE_DIRECTORY=""
TEST_RESOURCES_DIRECTORY=""
TEST_TARGET_NAME=""

setup_environment()
{
    UNAME=$(uname)

    if [ $UNAME == "Darwin" ]; then
        PLATFORM="x86_64-apple-macosx"
        EXECUTABLE_DIRECTORY="./.build/${PLATFORM}/debug"
        TEST_RESOURCES_DIRECTORY="$EXECUTABLE_DIRECTORY/debug/$TEST_TARGET_NAME.xctest/Contents/Resource"
        
        echo "[Success] Paths are set to:"
        echo " - EXECUTABLE_DIRECTORY: $EXECUTABLE_DIRECTORY"
        echo " - TEST_RESOURCES_DIRECTORY: $TEST_RESOURCES_DIRECTORY"
    fi

    if [ $UNAME == "Linux" ]; then
        echo "[Failure] Linux target isn't currently supported"
        exit 1
    fi
}

setup_test_target_name()
{
    package_description=$(swift package dump-package)

    all_targets_counted="false"

    for i in 0 1 2
    do
        target_type=$(echo $package_description | jq ".targets[$i].type")
        target_name=$(echo $package_description | jq ".targets[$i].name")

        if [ "$target_type" == "\"test\"" ]; then
            echo "[Success] Test target found: $target_name"
            TEST_TARGET_NAME=$(echo $target_name | tr -d '"')
        fi
        
        if [ "$target_type" == "null" ]; then
            echo "[Success] All targets counted: $i."
            all_targets_counted="true"
        fi
    done
    
    if [ "$all_targets_counted" == "false" ]; then
        echo "[Failure] It seems number of target changed. Please check copy resources logic in prepare_test_resource.sh"
        exit 2
    fi
}

echo " **** [Test Resources] **** "

echo ""
echo "[Step 1] Finding test target names using Package.swift..."
echo ""
setup_test_target_name
echo ""
echo "[Step 2] Calculating paths for testing and executing..."
echo ""
setup_environment

echo ""
echo " **** [Test Resources] **** "
echo ""
