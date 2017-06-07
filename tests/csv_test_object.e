class
	CSV_TEST_OBJECT

inherit
	CSV_SERIALIZABLE
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			my_string := "my_string_value"
			my_number := 99_999
			create my_decimal.make_from_string ("88.88")
			create my_date.make (2017,6,6)
		end

feature -- Access

	my_string: STRING

	my_number: INTEGER

	my_decimal: DECIMAL

	my_date: DATE

feature {NONE} -- Implementation

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<
						"my_string",
						"my_number",
						"my_decimal",
						"my_date"
					>>
		end

end
