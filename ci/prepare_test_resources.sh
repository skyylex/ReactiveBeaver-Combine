TEST_RESOURCES_URL="https://github.com/skyylex/ReactiveBeaverTestResources.git"
TEST_RESOURCES_REPO_NAME="ReactiveBeaverTestResources"

PLATFORM=""
EXECUTABLE_DIRECTORY=""
TEST_RESOURCES_DIRECTORY=""
TEST_PACKAGE_NAME=""

fetch_test_resources()
{
	if [ ! -d $TEST_RESOURCES_REPO_NAME ]; then
  		git clone $TEST_RESOURCES_URL
  	else
  		echo "Repository $TEST_RESOURCES_REPO_NAME was already cloned"
	fi
}

generate_book_paths()
{
	if [ ! -d $TEST_RESOURCES_DIRECTORY ]; then
  		mkdir $TEST_RESOURCES_DIRECTORY
  	fi

	./ci/fill_test_resources_paths.swift
}

echo " **** [Test Resources] **** "

echo ""
echo "[Step 0] Fetching remote resources..."
echo ""
fetch_test_resources
echo ""
echo "[Step 1] Generate book paths configuration file..."
echo ""
generate_book_paths
echo ""


echo ""
echo " **** [Test Resources] **** "
echo ""
