extends TestingFramework

func should_get_test_fixture():
	EXPECT_TRUE(get_test_fixture() != null)
	
	
func should_fail_to_get_test_fixture_when_missing_test_cases():
	get_parent().name = INVALID_TEST_FIXTURE_NAME
	
	EXPECT_TRUE(get_test_fixture() == null)
	
	get_parent().name = TEST_CASES_NODE_NAME


func should_fail_to_get_test_fixture_whith_missing_name_postfix():
	var test_cases: Node = get_parent()
	var test_fixture = test_cases.get_parent()
	var test_fixture_name: String = test_fixture.name
	test_fixture.name = INVALID_TEST_FIXTURE_NAME
		
	EXPECT_TRUE(get_test_fixture() == null)
	
	test_fixture.name = test_fixture_name
