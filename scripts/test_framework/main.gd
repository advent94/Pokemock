extends TestFixture

func run_tests():
		run_all_tests()

## Runs all tests implemented by owned test fixtures.
func run_all_tests():
	for child in get_children():
		run_test_fixture(child)
