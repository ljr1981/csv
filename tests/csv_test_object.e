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
		local
			l_list: ARRAY [TUPLE]
		do
			l_list := csv_split (a_line)		-- Compute me just one time! (then send me below)
			my_string := csv_object_to_eiffel_string_attached ("my_string", l_list)
			my_number := csv_object_to_eiffel_integer ("my_number", l_list)
			my_decimal := csv_object_to_eiffel_decimal ("my_decimal", l_list)
			my_date := csv_object_to_eiffel_date ("my_date", l_list)
			my_datetime := csv_object_to_eiffel_datetime ("my_datetime", l_list)
			my_time := csv_object_to_eiffel_time ("my_time", l_list)
			if attached {ARRAY [ANY]} csv_object_to_eiffel_array_attached ("my_array", l_list) as al_array then
				create my_array.make_filled ("", 1, al_array.count)
				across
					al_array as ic
				loop
					if attached {STRING} ic.item as al_string then
						my_array.put (al_string, ic.cursor_index)
					end
				end
			end
			if attached {ARRAYED_LIST [ANY]} csv_object_to_eiffel_arrayed_list_attached ("my_arrayed_list", l_list) as al_arrayed_list then
				create my_arrayed_list.make (al_arrayed_list.count)
				across
					al_arrayed_list as ic
				loop
					if attached {STRING} ic.item as al_item then
						my_arrayed_list.force (al_item)
					end
				end
			end
			my_tuple := csv_object_to_eiffel_tuple ("my_tuple", l_list)
			my_mixed := csv_object_to_eiffel_mixed ("my_mixed", l_list)
		end

	default_create
			-- <Precursor>
		do
			my_string := "my_string_value"
			my_number := 99999
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
		attribute
			create Result.make_empty
		end

	my_number: INTEGER

	my_decimal: DECIMAL
		attribute
			create Result.make_zero
		end

	my_date: DATE
		attribute
			create Result.make_now
		end

	my_datetime: DATE_TIME
		attribute
			create Result.make_now
		end

	my_time: TIME
		attribute
			create Result.make_now
		end

	my_array: ARRAY [STRING]
		attribute
			create Result.make_empty
		end

	my_arrayed_list: ARRAYED_LIST [STRING]
		attribute
			create Result.make (0)
		end

	my_tuple: TUPLE
		attribute
			create Result
		end

	my_mixed: FW_MIXED_NUMBER
		attribute
			create Result
		end

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
