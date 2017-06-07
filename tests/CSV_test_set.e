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
		end

	csv_object_representation_tests
		local
			l_object: CSV_TEST_OBJECT
		do
			create l_object.make_from_csv_line ("")
			assert_strings_equal ("object_one", object_one, l_object.representation_from_current (l_object))
		end

feature {NONE} -- Support

	object_one: STRING = "[
"my_string_value","88.88","20170606","20170606-10:15:30",["mo","curly","shemp"],["mo","curly","shemp"],["Blah",10,"Q"],[false,20,3,10],"10:30:45",99999
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
