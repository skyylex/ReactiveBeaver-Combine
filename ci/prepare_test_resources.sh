TEST_RESOURCES_URL="https://github.com/skyylex/ReactiveBeaverTestResources.git"
TEST_RESOURCES_REPO_NAME="ReactiveBeaverTestResources"

PLATFORM=""
EXECUTABLE_DIRECTORY=""
TEST_RESOURCES_DIRECTORY=""
TEST_PACKAGE_NAME=""

install_required_dependencies()
{
	brew install jq
}

fetch_test_resources()
{
	if [ ! -d $TEST_RESOURCES_REPO_NAME ]; then
  		git clone $TEST_RESOURCES_URL
  	else
  		echo "Repository $TEST_RESOURCES_REPO_NAME was already cloned"
	fi
}

copy_test_resources()
{
	if [ ! -d $TEST_RESOURCES_DIRECTORY ]; then
  		mkdir $TEST_RESOURCES_DIRECTORY
  	fi

	cp ReactiveBeaverTestResources/epub-books/*.epub $TEST_RESOURCES_DIRECTORY
}

setup_environment()
{
    UNAME=$(uname)

    if [ $UNAME == "Darwin" ]; then
        PLATFORM="x86_64-apple-macosx"
        EXECUTABLE_DIRECTORY="./.build/${PLATFORM}/debug"
        TEST_RESOURCES_DIRECTORY="$EXECUTABLE_DIRECTORY/$(echo $TEST_PACKAGE_NAME)PackageTests.xctest/Contents/Resource"
        
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

        if [ "$target_type" == "\"regular\"" ]; then
            echo "[Success] Main target found: $target_name"
            TEST_PACKAGE_NAME=$(echo $target_name | tr -d '"')
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
echo "[Step 0] Installing dependencies"
echo ""
install_required_dependencies
echo ""
echo "[Step 1] Finding test target names using Package.swift..."
echo ""
setup_test_target_name
echo ""
echo "[Step 2] Calculating paths for testing and executing..."
echo ""
setup_environment
echo ""
echo "[Step 3] Fetching remote resources..."
echo ""
fetch_test_resources
echo ""
echo "[Step 4] Copying resources..."
echo ""
copy_test_resources
echo ""


echo ""
echo " **** [Test Resources] **** "
echo ""
