deferred class
	CSV_SERIALIZABLE

inherit
	CSV_TRANSFORMABLE

feature {csv_SERIALIZABLE} -- Implementation: Unkeyed Conversions

	eiffel_object_to_csv_object (a_object: ANY): CSV_OBJECT
		local
			i, j: INTEGER
			l_convertible_features: ARRAYED_LIST [STRING]
			l_hash: HASH_TABLE [BOOLEAN, STRING]
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

			from i := 1
			until i > l_convertible_features.count
			loop
				l_hash.force (False, l_convertible_features.i_th (i))
				i := i + 1
			end
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
--					if is_not_persisting_long_strings and then attached {READABLE_STRING_GENERAL} l_field as al_string and then al_string.count > long_string_character_count then
--						Result.put (create {csv_STRING}.make_csv_from_string_32 (long_string_tag), l_key)
--					else
						Result.put (eiffel_to_csv (l_field, l_key), l_key)
--					end
				end
				j := j + 1
			end
		end

	eiffel_to_csv (a_field: detachable separate ANY; a_key: STRING): detachable CSV_VALUE
			-- ???
		do
			create {csv_NULL} Result
			if attached {CSV_SERIALIZABLE} a_field as al_convertible then
				Result := al_convertible.eiffel_object_to_csv_object (al_convertible)
--			elseif attached {ARRAY [detachable ANY]} a_field as al_array then
--				Result := eiffel_array_to_csv_array (al_array)
--			elseif attached {ARRAYED_LIST [detachable ANY]} a_field as al_array then
--				Result := eiffel_arrayed_list_to_csv_array (al_array)
--			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
--				Result := eiffel_mixed_number_csv_array (a_key, al_mixed_number)
--			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
--				Result := eiffel_tuple_to_csv_array (a_key, al_tuple)
--			elseif attached {DECIMAL} a_field as al_decimal then
--				Result := eiffel_decimal_to_csv_string (a_key, al_decimal)
--			elseif attached {DATE} a_field as al_date then
--				Result := eiffel_date_to_csv_string (a_key, al_date)
--			elseif attached {TIME} a_field as al_time then
--				Result := eiffel_time_to_csv_string (a_key, al_time)
--			elseif attached {DATE_TIME} a_field as al_date_time then
--				Result := eiffel_date_time_to_csv_string (a_key, al_date_time)
--			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
--				Result := eiffel_tuple_to_csv_array (a_key, al_tuple)
--			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
--				Result := eiffel_mixed_number_csv_array (a_key, al_mixed_number)
--			elseif attached {DECIMAL} a_field as al_decimal then
--				Result := eiffel_decimal_to_csv_string (a_key, al_decimal)
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
--			elseif attached {TUPLE [detachable ANY]} a_field as al_tuple then
--				Result := eiffel_tuple_to_csv_array (a_key, al_tuple)
--			elseif attached {FW_MIXED_NUMBER} a_field as al_mixed_number then
--				Result := eiffel_mixed_number_csv_array (a_key, al_mixed_number)
			elseif attached {DECIMAL} a_field as al_decimal then
				Result := eiffel_decimal_to_csv_string (a_key, al_decimal)
			end
		end

	eiffel_decimal_to_csv_string (a_key: STRING; a_decimal: detachable DECIMAL): CSV_STRING
			-- Convert `a_decimal' to JSON_STRING with `a_key'
			--| The `out_tuple' produces a tuple in the form of: [negative, coefficient, exponent]
			--| For example: 99.9 = [0,999,-1]
		do
			if attached a_decimal as al_decimal then
				create Result.make_csv_from_string_32 (al_decimal.out_tuple)
			else
				create Result.make_csv_from_string_32 ("void")
			end
		end

	eiffel_mixed_number_csv_array (a_key: STRING_8; a_mixed_number: FW_MIXED_NUMBER): CSV_ARRAY
			-- Converts `a_mixed_number` to CSV_ARRAY with the following specification:
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
end
