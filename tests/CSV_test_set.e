note
	description: "Tests of {CSV}."
	testing: "type/manual"

class
	CSV_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	csv_split_resource_test
		local
			l_mock: TEST_RESOURCE_OBJECT
			l_result: ARRAY [TUPLE]
		do
			create l_mock
			l_result := l_mock.csv_split (resource_csv_string)
			assert_integers_equal ("ten", 10, l_result.count)
			if attached l_result.item (5) as al_tuple and then attached {STRING} al_tuple [1] as al_item then
				assert_strings_equal ("a_b", "A,B", al_item)
			end
		end

	resource_csv_string: STRING
="[
"P1","RES1","Uber Res 1",null,"A,B","10","10","10","10","EACH"
]"

	csv_strip_test
		local
			l_test: TEST_TASK_OBJECT
			l_string: STRING
		do
			create l_test
			l_string := l_test.strip_head_tail_double_quotes ("%"BLAH%"")
			assert_strings_equal ("no_quotes", "BLAH", l_string)
			l_string := l_test.strip_head_tail_double_quotes ("%"%"")
			assert_strings_equal ("no_quotes", "", l_string)
			l_string := l_test.strip_head_tail_double_quotes ("%"BL%"AH%"")
			assert_strings_equal ("no_quotes", "BL%"AH", l_string)
		end

	csv_split_example_task_test
		local
			l_task: TEST_TASK_OBJECT
			l_list: ARRAY [TUPLE]
			l_item: STRING
		do
			create l_task
			l_list := l_task.csv_split (task_template_line_example)
--						"project_key",
			check item_1_string: attached {STRING} l_list [1].item (1) as al_item then
				assert_strings_equal ("item_1", "", al_item)
			end
--						"key",
			check item_2_string: attached {STRING} l_list [2].item (1) as al_item then
				assert_strings_equal ("item_2", "TT1", al_item)
			end
--						"name",
			check item_3_string: attached {STRING} l_list [3].item (1) as al_item then
				assert_strings_equal ("item_3", "TASK_NAME1", al_item)
			end
--						"predecessors",4
--						"labor_type",5
			check item_5_string: attached {STRING} l_list [5].item (1) as al_item then
				assert_strings_equal ("item_5", "LABOR_TYPE1", al_item)
			end
--						"material_type",
--						"uom",
--						"est_qty",
--						"est_qty_per_day",
--						"est_qty_per_hour",
--						"act_quantities",
--						"cost_per_unit"
		end

	task_template_line_example: STRING = "[
"","TT1","TASK_NAME1",[""],"LABOR_TYPE1","MAT_TYPE1","EACH","10.00","20.00","30.00","","40.00"
]"

	csv_split_example_test
		local
			l_test: TEST_RESOURCE_OBJECT
			l_list: ARRAY [TUPLE]
			l_item: STRING
		do
			create l_test
			l_list := l_test.csv_split ("%"<><JAN-DEC><MON-FRI><0800-1700><>") -- This works ... it fails (below) in wider context!
			-- l_list := l_test.csv_split ("%"%",%"RT1%",%"RES1%",,%"[<><JAN-DEC><MON-FRI><0800-1700><>]]%",%"0%",%"10.00%",%"20.00%",%"30.00%",%"EACH%"")
				-- ERROR: The mistake is the doublt ]] in the text above.
				-- BUG: The code is very brittle and fails without grace because of it.
				-- SOLUTION(S):
				--	(1) Put a require contract that scans to ensure the count of "[" matches the count of "]", but this
				--		just moves the failure to the caller, but that might be good because the caller can be more robust!
				-- SO: I have added the require, so where the above failed, removing the double "]]" now allows this code to work!
			l_list := l_test.csv_split ("%"%",%"RT1%",%"RES1%",%"%",%"[<><JAN-DEC><MON-FRI><0800-1700><>]%",%"0%",%"10.00%",%"20.00%",%"30.00%",%"EACH%"")
			l_list := l_test.csv_split (resource_line_example)
			assert_integers_equal ("has_10", 10, l_list.count)
--						"project_key",
			check item_1_string: attached {STRING} l_list [1].item (1) as al_item then
				assert_strings_equal ("item_1", "", al_item)
			end
--						"key",
			check item_2_string: attached {STRING} l_list [2].item (1) as al_item then
				assert_strings_equal ("item_1", "RT1", al_item)
			end
--						"name",
			check item_3_string: attached {STRING} l_list [3].item (1) as al_item then
				assert_strings_equal ("item_1", "RES1", al_item)
			end
--						"types",
			check item_4_string: attached {STRING} l_list [4].item (1) as al_item then
				assert_strings_equal ("item_1", "", al_item)
			end
--						"spec",
			check item_5_string: attached {STRING} l_list [5].item (1) as al_item then
				assert_strings_equal ("item_1", "<><JAN-DEC><MON-FRI><0800-1700><>", al_item)
			end
--						"cubic_feet",
			check item_6_string: attached {STRING} l_list [6].item (1) as al_item then
				assert_strings_equal ("item_1", "0", al_item)
			end
--						"cost_fixed",
			check item_7_string: attached {STRING} l_list [7].item (1) as al_item then
				assert_strings_equal ("item_1", "10.00", al_item)
			end
--						"cost_per_hour",
			check item_8_string: attached {STRING} l_list [8].item (1) as al_item then
				assert_strings_equal ("item_1", "20.00", al_item)
			end
--						"cost_to_purchase",
			check item_9_string: attached {STRING} l_list [9].item (1) as al_item then
				assert_strings_equal ("item_1", "30.00", al_item)
			end
--						"uom"
			check item_10_string: attached {STRING} l_list [10].item (1) as al_item then
				assert_strings_equal ("item_1", "EACH", al_item)
			end

		end

	resource_line_example: STRING = "[
"","RT1","RES1","","<><JAN-DEC><MON-FRI><0800-1700><>","0","10.00","20.00","30.00","EACH"
]"

	csv_split_test_2
		local
			l_test: CSV_TEST_OBJECT
			l_list: ARRAY [TUPLE]
		do
			create l_test
			l_list := l_test.csv_split (csv_split_test_2_string)
		end

	csv_split_test_2_string: STRING = "[
,"FW01","FORMWORK TO FOOTINGS","[]",,,"EACH","0","12","12","[]","0","null","null","null","null","null"
]"

	csv_split_test_3
		local
			l_test: CSV_TEST_OBJECT
			l_list: ARRAY [TUPLE]
		do
			create l_test
			l_list := l_test.csv_split (csv_split_test_3_string)
		end

	csv_split_test_3_string: STRING = "[
,"FW 59","DE-SHUTTERING MANHOLES, SQUARE - CIRCULAR (TIMBER)","[]",,,"EACH","0","40","40","[]","0","null","null","null","null","null"
]"

	csv_split_test
		local
			l_test: CSV_TEST_OBJECT
			l_list: ARRAY [TUPLE]
		do
			create l_test
			l_list := l_test.csv_split (array_string)
			assert_integers_equal ("array_string", 1, l_list.count)
			l_list := l_test.csv_split (object_one)
			assert_integers_equal ("object_one", 10, l_list.count)

			create l_test.make_from_csv_line (object_one)
			assert_strings_equal ("my_string_value", "my_string_value", l_test.my_string)
			assert_strings_equal ("my_number_value", "99999", l_test.my_number.out)
			assert_strings_equal ("my_decimal_value", "88.88", l_test.my_decimal.to_engineering_string)
			assert_strings_equal ("my_date_value", "06/06/2017", l_test.my_date.out)
			assert_strings_equal ("my_datetime_value", "06/06/2017 10:15:30.000 AM", l_test.my_datetime.out)
			assert_integers_equal ("my_array_count", 3, l_test.my_array.count)
			assert_integers_equal ("my_arrayed_list_count", 3, l_test.my_arrayed_list.count)
			check attached l_test.my_tuple [1] as al_item then
				assert_strings_equal ("my_tuple_value_1", "Blah", al_item.out)
			end
			check has_int: attached l_test.my_tuple [2] as al_item then
				assert_strings_equal ("my_tuple_value_2", "10", al_item.out)
				check is_int: attached {INTEGER} al_item as al_integer then
					assert_integers_equal ("my_tuple_value_2_int", 10, al_integer)
				end
			end
			check has_q: attached l_test.my_tuple [3] as al_item then
				assert_strings_equal ("my_tuple_value_3", "Q", al_item.out)
			end
			assert_strings_equal ("mixed", "20 3/10", l_test.my_mixed.out)

			create l_test.make_from_csv_line (object_two)
			assert_strings_equal ("my_string_value_2", "my_other_string", l_test.my_string)
			assert_strings_equal ("my_number_value_2", "888888", l_test.my_number.out)
			assert_strings_equal ("my_decimal_value_2", "77.77", l_test.my_decimal.to_engineering_string)
			assert_strings_equal ("my_date_value_2", "01/01/2017", l_test.my_date.out)
			assert_strings_equal ("my_datetime_value_2", "01/01/2017 10:15:30.000 AM", l_test.my_datetime.out)
			assert_integers_equal ("my_array_count_2", 3, l_test.my_array.count)
			assert_integers_equal ("my_arrayed_list_count_2", 3, l_test.my_arrayed_list.count)
			check attached l_test.my_tuple [1] as al_item then
				assert_strings_equal ("my_tuple_value_1_2", "Blah2", al_item.out)
			end
			check has_int: attached l_test.my_tuple [2] as al_item then
				assert_strings_equal ("my_tuple_value_2_2", "20", al_item.out)
				check is_int: attached {INTEGER} al_item as al_integer then
					assert_integers_equal ("my_tuple_value_2_int_2", 20, al_integer)
				end
			end
			check has_q: attached l_test.my_tuple [3] as al_item then
				assert_strings_equal ("my_tuple_value_3_2", "R", al_item.out)
			end
			assert_strings_equal ("mixed_2", "15 1/5", l_test.my_mixed.out)
		end

	csv_object_representation_tests
		local
			l_object: CSV_TEST_OBJECT
		do
			create l_object
			assert_strings_equal ("object_one", object_one, l_object.representation_from_current (l_object))
		end

feature {NONE} -- Support

	object_one: STRING = "[
"my_string_value",99999,"88.88","20170606","20170606-10:15:30","10:30:45",["mo","curly","shemp"],["mo","curly","shemp"],["Blah",10,"Q"],[false,20,3,10]
]"

	object_two: STRING = "[
"my_other_string",888888,"77.77","20170101","20170101-10:15:30","10:31:46",["bugs","daffy","porky"],["foghorn","wiley","roadrunner"],["Blah2",20,"R"],[true,15,1,5]
]"

feature -- Testing

	csv_in_system_tests
			-- `CSV_tests'
		local
			l_constants: CSV_CONSTANTS

				-- Transformable and descendants
			l_transformable: CSV_TRANSFORMABLE
			l_csv_serializable: CSV_SERIALIZABLE

				-- Value and descendants
			l_csv_value: CSV_VALUE
			l_csv_null: CSV_NULL
			l_csv_string: CSV_STRING
			l_csv_number: CSV_NUMBER
			l_csv_boolean: CSV_BOOLEAN
			l_csv_date: CSV_DATE
			l_csv_array: CSV_ARRAY

				-- Objects to test with
			l_csv_test_object: CSV_TEST_OBJECT
		do
			do_nothing -- yet ...
		end

	csv_array_tests
		local
			l_array: CSV_ARRAY
			l_object: CSV_OBJECT
		do
			create l_array.make (10)
			l_array.add (create {CSV_STRING}.make_from_string ("blah1"))
			l_array.add (create {CSV_STRING}.make_from_string ("blah2"))
			l_array.add (create {CSV_NULL})
			l_array.add (create {CSV_NUMBER}.make_integer (999))
			l_array.add (create {CSV_NUMBER}.make_natural (888))
			l_array.add (create {CSV_NUMBER}.make_real (9.87))
			l_array.add (create {CSV_NUMBER}.make_string ("666"))
			l_array.add (create {CSV_NUMBER}.make_decimal (create {DECIMAL}.make_from_string ("555")))
			l_array.add (create {CSV_BOOLEAN}.make (True))
			l_array.add (create {CSV_BOOLEAN}.make (False))
			l_array.add (create {CSV_BOOLEAN}.make_true)
			l_array.add (create {CSV_BOOLEAN}.make_false)
			l_array.add (create {CSV_DATE}.make (2017, 6, 6))
			assert_strings_equal ("array_string", array_string, l_array.representation)

			create l_array.make (10)
			create l_object
			l_array.add (l_object)
			l_object.put (create {CSV_STRING}.make_from_string ("blah1"), "blah1")
			l_object.put (create {CSV_STRING}.make_from_string ("blah2"), "blah2")
			assert_strings_equal ("object_string", object_string, l_object.representation)
			assert_strings_equal ("array_in_object_string", array_in_object_string, l_array.representation)

		end

feature {NONE} -- Support

	object_string: STRING = "[
"blah1","blah2"
]"
	array_in_object_string: STRING = "[
["blah1","blah2"]
]"

	array_string: STRING = "[
["blah1","blah2",null,999,888,9.8699999999999992,666,555,true,false,true,false,06/06/2017]
]"

feature -- Tests

	csv_null_tests
		local
			l_null: CSV_NULL
		do
			create l_null
			assert_strings_equal ("null", "null", l_null.representation)
		end

	csv_string_tests
		local
			l_string: CSV_STRING
		do
			create l_string.make_from_escaped_csv_string ("blah")
			assert_strings_equal ("string_1", "%"blah%"", l_string.representation)
			create l_string.make_from_string ("blah")
			assert_strings_equal ("string_2", "%"blah%"", l_string.representation)
			create l_string.make_from_string_32 (create {STRING_32}.make_from_string ("blah"))
			assert_strings_equal ("string_3", "%"blah%"", l_string.representation)
			create l_string.make_from_string_general ("blah")
			assert_strings_equal ("string_4", "%"blah%"", l_string.representation)
		end

	csv_number_tests
		local
			l_number: CSV_NUMBER
		do
			create l_number.make_integer (create {INTEGER})
			assert_strings_equal ("integer_number", "0", l_number.representation)
			create l_number.make_natural (create {NATURAL})
			assert_strings_equal ("natural_number", "0", l_number.representation)
			create l_number.make_real (create {REAL})
			assert_strings_equal ("real_number", "0", l_number.representation)
		end

	csv_boolean_tests
		local
			l_bool: CSV_BOOLEAN
		do
			create l_bool.make (True)
			assert_strings_equal ("true_1", "true", l_bool.representation)
			create l_bool.make (False)
			assert_strings_equal ("false_1", "false", l_bool.representation)
			create l_bool.make_false
			assert_strings_equal ("false_2", "false", l_bool.representation)
			create l_bool.make_true
			assert_strings_equal ("true_2", "true", l_bool.representation)
		end

	csv_date_tests
		local
			l_date: CSV_DATE
		do
			create l_date.make (2001, 1, 1)
			assert_strings_equal ("2001_01_01", "01/01/2001", l_date.representation)
			create l_date.make_by_days (777)
			assert_strings_equal ("1602_02_16", "02/16/1602", l_date.representation)
			create l_date.make_from_date (create {DATE}.make (2017, 06, 06))
			assert_strings_equal ("2017_06_06", "06/06/2017", l_date.representation)
		end

end
