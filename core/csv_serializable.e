deferred class
	CSV_SERIALIZABLE

inherit
	CSV_TRANSFORMABLE

feature -- Output

	representation: STRING
		attribute
			create Result.make_empty
		end

feature -- Access

	representation_from_current (a_current: ANY): STRING
			-- CSV representation of Current (`a_current').
		do
			Result := eiffel_object_to_csv_object (a_current).representation
		end

feature {CSV_SERIALIZABLE} -- Implementation: Unkeyed Conversions

	eiffel_object_to_csv_object (a_object: ANY): CSV_OBJECT
		local
			i, j: INTEGER
			l_convertible_features: ARRAYED_LIST [STRING]
			l_hash: HASH_TABLE [BOOLEAN, STRING]
			l_result_hash: HASH_TABLE [detachable CSV_VALUE, STRING]
			l_reflector: INTERNAL
			l_key: STRING
			l_field: detachable ANY
			l_csv_key: CSV_STRING
			l_csv_value: detachable CSV_VALUE
			l_is_void: BOOLEAN
		do
			create Result
			create l_reflector
			create l_convertible_features.make_from_array (convertible_features (a_object))
			create l_hash.make (0)
			l_hash.compare_objects

				-- Load up our convertible features in order!
			from i := 1
			until i > l_convertible_features.count
			loop
				l_hash.force (False, l_convertible_features.i_th (i))
				i := i + 1
			end

				-- Create the result hash with enough room ...
			create l_result_hash.make (l_convertible_features.count)

				-- Load up the result in whatever order the features are in the object
			from j := 1
			until j > l_reflector.field_count (a_object)
			loop
				l_key := l_reflector.field_name (j, a_object).twin
				if l_hash.has (l_key) then
					l_hash.force (True, l_key)
					check has_key: l_hash.has_key (l_key) end
					l_field := l_reflector.field (j, a_object)
					create l_csv_key.make_from_string (l_key)
					l_csv_value := Void
					l_is_void := False
					l_result_hash.put (eiffel_to_csv (l_field, l_key), l_key)
				end
				j := j + 1
			end

				-- Go over the convertibles in order, finding their result hash items and putting them
				--	into the Result in the order of the convertibles ...
			across
				l_convertible_features as ic_features
			loop
				check attached l_result_hash.item (ic_features.item) as al_item then
					Result.put (al_item, ic_features.item)
				end
			end
		end

	eiffel_to_csv (a_field: detachable separate ANY; a_key: STRING): detachable CSV_VALUE
			-- ???
		do
			create {CSV_NULL} Result
			if attached {CSV_SERIALIZABLE} a_field as al_convertible then
				Result := al_convertible.eiffel_object_to_csv_object (al_convertible)
			elseif attached {ARRAY [detachable ANY]} a_field as al_array then
				Result := eiffel_array_to_csv_array (al_array)
			elseif attached {ARRAYED_LIST [detachable ANY]} a_field as al_array then
				Result := eiffel_arrayed_list_to_csv_array (al_array)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				Result := eiffel_mixed_number_csv_array (a_key, al_mixed_number)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := eiffel_tuple_to_csv_array (a_key, al_tuple)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_csv_string (a_key, al_decimal)
			elseif attached {DATE} a_field as al_date then
				Result := eiffel_date_to_csv_string (a_key, al_date)
			elseif attached {TIME} a_field as al_time then
				Result := eiffel_time_to_csv_string (a_key, al_time)
			elseif attached {DATE_TIME} a_field as al_date_time then
				Result := eiffel_date_time_to_csv_string (a_key, al_date_time)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := eiffel_tuple_to_csv_array (a_key, al_tuple)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				Result := eiffel_mixed_number_csv_array (a_key, al_mixed_number)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_csv_string (a_key, al_decimal)
			elseif attached a_field as al_field then
				Result := eiffel_any_to_csv_value (a_key, al_field)
			end
		end

	eiffel_any_to_csv_value (a_key: STRING; a_field: separate ANY): detachable CSV_VALUE
			-- If possible, convert various Eiffel types to CSV types given `a_key', `a_field'.
		local
			l_csv_key: CSV_STRING
			l_csv_value: detachable CSV_VALUE
			l_is_void: BOOLEAN
		do
			create {CSV_NULL} Result
			create l_csv_key.make_csv_from_string_32 (a_key)
			l_csv_value := Void
			l_is_void := False

			if attached {CSV_SERIALIZABLE} a_field as al_convertible then
				Result := al_convertible.eiffel_object_to_csv_object (al_convertible)
			elseif attached {CHARACTER_8} a_field as al_field then
				create {CSV_STRING} Result.make_csv_from_string_32 (al_field.out)
			elseif attached {IMMUTABLE_STRING_8} a_field as al_field then
				create {CSV_STRING} Result.make_csv_from_string_32 (al_field.out)
			elseif attached {IMMUTABLE_STRING_32} a_field as al_field then
				create {CSV_STRING} Result.make_csv_from_string_32 (al_field.out)
			elseif attached {STRING_8} a_field as al_field then
				create {CSV_STRING} Result.make_csv_from_string_32 (al_field)
			elseif attached {STRING_32} a_field as al_field then
				create {CSV_STRING} Result.make_csv_from_string_32 (al_field)
			elseif attached {INTEGER_8} a_field as al_integer then
				create {CSV_NUMBER} Result.make_integer (al_integer)
			elseif attached {INTEGER_16} a_field as al_integer then
				create {CSV_NUMBER} Result.make_integer (al_integer)
			elseif attached {INTEGER_32} a_field as al_integer then
				create {CSV_NUMBER} Result.make_integer (al_integer)
			elseif attached {INTEGER_64} a_field as al_integer then
				create {CSV_NUMBER} Result.make_integer (al_integer)
			elseif attached {NATURAL_8} a_field as al_natural then
				create {CSV_NUMBER} Result.make_natural (al_natural)
			elseif attached {NATURAL_16} a_field as al_natural then
				create {CSV_NUMBER} Result.make_natural (al_natural)
			elseif attached {NATURAL_32} a_field as al_natural then
				create {CSV_NUMBER} Result.make_natural (al_natural)
			elseif attached {NATURAL_64} a_field as al_natural then
				create {CSV_NUMBER} Result.make_natural (al_natural)
			elseif attached {REAL_32} a_field as al_real then
				create {CSV_NUMBER} Result.make_real (al_real)
			elseif attached {REAL_64} a_field as al_real then
				create {CSV_NUMBER} Result.make_real (al_real)
			elseif attached {BOOLEAN} a_field as al_boolean then
				create {CSV_BOOLEAN} Result.make_boolean (al_boolean)
			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
				Result := eiffel_tuple_to_csv_array (a_key, al_tuple)
			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
				Result := eiffel_mixed_number_csv_array (a_key, al_mixed_number)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_csv_string (a_key, al_decimal)
			end
		end

	eiffel_decimal_to_csv_string (a_key: STRING; a_decimal: detachable DECIMAL): CSV_STRING
			-- Convert `a_decimal' to {CSV_STRING} with `a_key'
			--| The `out_tuple' produces a tuple in the form of: [negative, coefficient, exponent]
			--| For example: 99.9 = [0,999,-1]
		do
			if attached a_decimal as al_decimal then
				create Result.make_csv_from_string_32 (al_decimal.to_engineering_string)
			else
				create Result.make_csv_from_string_32 ("void")
			end
		end

	eiffel_mixed_number_csv_array (a_key: STRING_8; a_mixed_number: FW_MIXED_NUMBER): CSV_ARRAY
			-- Converts `a_mixed_number` to {CSV_ARRAY} with the following specification:
			-- "feature_name":[is_negative, whole_part, numerator, denominator]
			-- (export status {NONE})
		local
			l_negative: CSV_BOOLEAN
			l_whole_part: CSV_NUMBER
			l_numerator: CSV_NUMBER
			l_denominator: CSV_NUMBER
		do
			create l_negative.make_boolean (a_mixed_number.is_negative)
			create l_whole_part.make_integer (a_mixed_number.whole_part.as_integer_64)
			create l_numerator.make_integer (a_mixed_number.numerator.to_integer_64)
			create l_denominator.make_integer (a_mixed_number.denominator.to_integer_64)
			create Result.make_array
			Result.add (l_negative)
			Result.add (l_whole_part)
			Result.add (l_numerator)
			Result.add (l_denominator)
		ensure
			four_values: Result.count = 4
			first_boolean: attached {CSV_BOOLEAN} Result.i_th (1)
			second_number: attached {CSV_NUMBER} Result.i_th (2)
			second_same_number: Result.i_th (2).is_equal (create {CSV_NUMBER}.make_integer (a_mixed_number.whole_part.as_integer_64))
			third_number: attached {CSV_NUMBER} Result.i_th (3)
			third_same_number: Result.i_th (3).is_equal (create {CSV_NUMBER}.make_integer (a_mixed_number.numerator.to_integer_64))
			fourth_number: attached {CSV_NUMBER} Result.i_th (4)
			fourth_same_number: Result.i_th (4).is_equal (create {CSV_NUMBER}.make_integer (a_mixed_number.denominator.to_integer_64))
		end

	eiffel_date_to_csv_string (a_key: STRING; a_date: DATE): CSV_STRING
			-- Convert `a_date' to {CSV_STRING} with `a_key'
		local
			l_yyyymmdd: STRING
		do
			l_yyyymmdd := a_date.year.out

			if a_date.month < 10 then
				l_yyyymmdd.append_character ('0')
			end
			l_yyyymmdd.append_string (a_date.month.out)

			if a_date.day < 10 then
				l_yyyymmdd.append_character ('0')
			end
			l_yyyymmdd.append_string (a_date.day.out)

			create Result.make_csv_from_string_32 (l_yyyymmdd)
		end


	eiffel_time_to_csv_string (a_key: STRING; a_time: TIME): CSV_STRING
			-- Convert `a_time' to CSV_STRING with `a_key'
		do
			create Result.make_csv_from_string_32 (a_time.hour.out + ":" + a_time.minute.out + ":" + a_time.second.out)
		end

	eiffel_date_time_to_csv_string (a_key: STRING; a_date_time: DATE_TIME): CSV_STRING
			-- Convert `a_date_time' to CSV_STRING with `a_key'
		local
			l_yyyymmdd: STRING
		do
			l_yyyymmdd := a_date_time.year.out

			if a_date_time.month < 10 then
				l_yyyymmdd.append_character ('0')
			end
			l_yyyymmdd.append_string (a_date_time.month.out)

			if a_date_time.day < 10 then
				l_yyyymmdd.append_character ('0')
			end
			l_yyyymmdd.append_string (a_date_time.day.out)

			create Result.make_csv_from_string_32 (l_yyyymmdd + "-" + a_date_time.hour.out + ":" + a_date_time.minute.out + ":" + a_date_time.second.out)
		end

	eiffel_tuple_to_csv_array (a_key: STRING; a_tuple: TUPLE [detachable separate ANY]): CSV_ARRAY
			-- Convert `a_tuple' to {CSV_ARRAY} with `a_key'
		local
			i: INTEGER
		do
			create Result.make_array
			from i := 1
			until i > a_tuple.count
			loop
				if attached eiffel_to_csv (a_tuple.item (i), a_key) as al_value then
					Result.add (al_value)
				end
				i := i + 1
			end
		end

	eiffel_array_to_csv_array (a_array: ARRAY [detachable ANY]): CSV_ARRAY
			-- Converts `a_special' ({ARRAY} or {ARRAYED_LIST}) to {CSV_ARRAY}.
			-- Detachable elements are represented by {CSV_NULL} in Result.
		local
			k: INTEGER
		do
			create Result.make_array
			if attached {ARRAY [detachable ANY]} a_array as al_array then
				from k := 1
				until k > al_array.count
				loop
					if attached al_array.item (k) as al_item then
						if attached {CSV_SERIALIZABLE} al_item as al_convertible then
							Result.add (al_convertible.eiffel_object_to_csv_object (al_convertible))
						elseif attached {ARRAY [detachable ANY]} al_item as al_array_item then
							Result.add (eiffel_array_to_csv_array (al_array_item))
						elseif attached {ARRAYED_LIST [detachable ANY]} al_item as al_arrayed_list_item then
							Result.add (eiffel_arrayed_list_to_csv_array (al_arrayed_list_item))
						else
							if attached eiffel_any_to_csv_value ("element_" + k.out, al_item) as al_value then
								Result.add (al_value)
							else
								Result.add (create {CSV_NULL})
							end
						end
					else
						Result.add (create {CSV_NULL})
					end
					k := k + 1
				end
			end
		end

	eiffel_arrayed_list_to_csv_array (a_arrayed_list: ARRAYED_LIST [detachable ANY]): CSV_ARRAY
			-- Converts `a_special' ({ARRAY} or {ARRAYED_LIST}) to {CSV_ARRAY}.
			-- Detachable elements are represented by {CSV_NULL} in Result.
		local
			k: INTEGER
		do
			create Result.make_array
			if attached {ARRAYED_LIST [detachable ANY]} a_arrayed_list as al_arrayed_list then
				from al_arrayed_list.start
				until al_arrayed_list.exhausted
				loop
					if attached al_arrayed_list.item_for_iteration as al_item then
						if attached {CSV_SERIALIZABLE} al_item as al_convertible then
							Result.add (al_convertible.eiffel_object_to_csv_object (al_convertible))
						elseif attached {ARRAY [detachable ANY]} al_item as al_array_item then
							Result.add (eiffel_array_to_csv_array (al_array_item))
						elseif attached {ARRAYED_LIST [detachable ANY]} al_item as al_arrayed_list_item then
							Result.add (eiffel_arrayed_list_to_csv_array (al_arrayed_list_item))
						elseif attached {DECIMAL} al_item as al_decimal then
							Result.add (create {CSV_STRING}.make_from_string (al_decimal.to_engineering_string))
						else
							if attached eiffel_any_to_csv_value ("element_" + k.out, al_item) as al_value then
								Result.add (al_value)
							else
								Result.add (create {CSV_NULL})
							end
						end
					else
						Result.add (create {CSV_NULL})
					end
					al_arrayed_list.forth
				end
			end
		end

end
