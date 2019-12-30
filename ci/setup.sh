./ci/install_dependencies.sh

# Building tests target to produce PackageTests.xctest in which test resources would be placed
swift build --build-tests

./ci/prepare_test_resources.sh
