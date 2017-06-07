class
	CSV_TEST_OBJECT

inherit
	CSV_SERIALIZABLE
		redefine
			default_create
		end

	CSV_DESERIALIZABLE
		undefine
			default_create
		end

create
	default_create,
	make_from_csv_line

feature {NONE} -- Initialization

	make_from_csv_line (a_line: STRING)
		do
			default_create -- ERASE ME WHEN DONE!
			my_string := "blah_to_overwrite"
			my_string := csv_object_to_eiffel_string_attached ("my_string", a_line)
		end

	default_create
			-- <Precursor>
		do
			my_string := "my_string_value"
			my_number := 99_999
			create my_decimal.make_from_string ("88.88")
			create my_date.make (2017,6,6)
			create my_datetime.make (2017,6,6,10,15,30)
			create my_time.make (10,30,45)
			my_array := <<"mo","curly","shemp">>
			create my_arrayed_list.make_from_array (my_array)
			my_tuple := ["Blah", 10, 'Q']
			create my_mixed.make (False, 20, 3, 10)
		end

feature -- Access

	my_string: STRING

	my_number: INTEGER

	my_decimal: DECIMAL

	my_date: DATE

	my_datetime: DATE_TIME

	my_time: TIME

	my_array: ARRAY [STRING]

	my_arrayed_list: ARRAYED_LIST [STRING]

	my_tuple: TUPLE

	my_mixed: FW_MIXED_NUMBER

feature {NONE} -- Implementation

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<
						"my_string",
						"my_number",
						"my_decimal",
						"my_date",
						"my_datetime",
						"my_time",
						"my_array",
						"my_arrayed_list",
						"my_tuple",
						"my_mixed"
					>>
		end

end
