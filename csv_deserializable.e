deferred class
	CSV_DESERIALIZABLE

inherit
	CSV_TRANSFORMABLE

feature {NONE} -- Initialization

	make_from_csv_line (a_csv_line: STRING)
		deferred
		end

feature -- Converters: STRING

	csv_object_to_eiffel_string (a_key: STRING; a_list: ARRAY [TUPLE]): detachable STRING
		do
			Result := string_for_key (a_key, a_list)
		end

	csv_object_to_eiffel_string_attached (a_key: STRING; a_list: ARRAY [TUPLE]): STRING
		do
			Result := string_for_key_attached (a_key, a_list)
		end

feature -- Converters: NUMBER (INTEGER, REAL, NATURAL, DECIMAL)

	csv_object_to_eiffel_integer (a_key: STRING; a_list: ARRAY [TUPLE]): INTEGER
		do
			check is_integer:
				attached {STRING} csv_object_to_eiffel_number (a_key, a_list) as al_string
					and then attached {INTEGER} al_string.to_integer as al_result
			then
				Result := al_result
			end
		end

	csv_object_to_eiffel_decimal (a_key: STRING; a_list: ARRAY [TUPLE]): DECIMAL
		do
			check is_decimal:
				attached {STRING} csv_object_to_eiffel_number (a_key, a_list) as al_string
			then
				create {DECIMAL} Result.make_from_string (al_string)
			end
		end

	csv_object_to_eiffel_real_32 (a_key: STRING; a_list: ARRAY [TUPLE]): REAL_32
		do
			check is_real_32:
				attached {STRING} csv_object_to_eiffel_number (a_key, a_list) as al_string
					and then attached {REAL} al_string.to_real_32 as al_result
			then
				Result := al_result
			end
		end

	csv_object_to_eiffel_real_64 (a_key: STRING; a_list: ARRAY [TUPLE]): REAL_64
		do
			check is_real_64:
				attached {STRING} csv_object_to_eiffel_number (a_key, a_list) as al_string
					and then attached {REAL_64} al_string.to_real_64 as al_result
			then
				Result := al_result
			end
		end

	csv_object_to_eiffel_number (a_key: STRING; a_list: ARRAY [TUPLE]): STRING
		do
			check is_string:
				attached {TUPLE [STRING]} tuple_for_key_attached (a_key, a_list) as al_tuple_string
					and then attached {STRING} al_tuple_string [1] as al_payload
			then
				Result := al_payload
				Result.remove_head (1)
				Result.remove_tail (1)
				check is_numeric: Result.is_integer or Result.is_real or Result.is_natural end
			end
		end

feature -- Converters: DATE

	csv_object_to_eiffel_date (a_key: STRING; a_list: ARRAY [TUPLE]): DATE
		do
			check is_string_date:
				attached {TUPLE [STRING]} tuple_for_key_attached (a_key, a_list) as al_tuple_string
					and then attached {STRING} al_tuple_string [1] as al_payload
			then
				if al_payload [1] = '"' then -- "20170606"
					create Result.make (al_payload.substring (2, 5).to_integer,
										al_payload.substring (6, 7).to_integer,
										al_payload.substring (8, 9).to_integer)
				else 						-- 20170606
					create Result.make (al_payload.substring (1, 4).to_integer,
										al_payload.substring (5, 6).to_integer,
										al_payload.substring (7, 8).to_integer)
				end
			end
		end

	csv_object_to_eiffel_datetime (a_key: STRING; a_list: ARRAY [TUPLE]): DATE_TIME
		do
			check is_string_date:
				attached {TUPLE [STRING]} tuple_for_key_attached (a_key, a_list) as al_tuple_string
					and then attached {STRING} al_tuple_string [1] as al_payload
			then
				if al_payload [1] = '"' then -- "20170606-10:15:30"
					create Result.make (al_payload.substring (2, 5).to_integer,
										al_payload.substring (6, 7).to_integer,
										al_payload.substring (8, 9).to_integer,
										al_payload.substring (11, 12).to_integer,
										al_payload.substring (14, 15).to_integer,
										al_payload.substring (17, 18).to_integer)
				else 						-- 20170606-10:15:30
					create Result.make (al_payload.substring (1, 4).to_integer,
										al_payload.substring (5, 6).to_integer,
										al_payload.substring (7, 8).to_integer,
										al_payload.substring (10, 11).to_integer,
										al_payload.substring (13, 14).to_integer,
										al_payload.substring (16, 17).to_integer)
				end
			end
		end

	csv_object_to_eiffel_time (a_key: STRING; a_list: ARRAY [TUPLE]): TIME
		do
			check is_string_date:
				attached {TUPLE [STRING]} tuple_for_key (a_key, a_list) as al_tuple_string
					and then attached {STRING} al_tuple_string [1] as al_payload
			then
				if al_payload [1] = '"' then -- "20170606-10:15:30"
					create Result.make (al_payload.substring (2, 3).to_integer,
										al_payload.substring (5, 6).to_integer,
										al_payload.substring (8, 9).to_integer)
				else 						-- 20170606-10:15:30
					create Result.make (al_payload.substring (1, 2).to_integer,
										al_payload.substring (4, 5).to_integer,
										al_payload.substring (7, 8).to_integer)
				end
			end
		end

	csv_object_to_eiffel_array (a_key: STRING; a_list: ARRAY [TUPLE]): ARRAY [detachable ANY]
		local
			l_tuple: TUPLE
			l_arrayed_list: ARRAYED_LIST [detachable ANY]
		do
			l_tuple := csv_object_to_eiffel_tuple (a_key, a_list)
			create l_arrayed_list.make (l_tuple.count)
			across
				l_tuple as ic
			loop
				l_arrayed_list.force (ic.item)
			end
			Result := l_arrayed_list.to_array
		end

	csv_object_to_eiffel_array_attached (a_key: STRING; a_list: ARRAY [TUPLE]): ARRAY [ANY]
		local
			l_tuple: TUPLE
			l_arrayed_list: ARRAYED_LIST [ANY]
		do
			l_tuple := csv_object_to_eiffel_tuple (a_key, a_list)
			create l_arrayed_list.make (l_tuple.count)
			across
				l_tuple as ic
			loop
				if attached ic.item as al_item then
					l_arrayed_list.force (al_item)
				end
			end
			Result := l_arrayed_list.to_array
		end

	csv_object_to_eiffel_arrayed_list (a_key: STRING; a_list: ARRAY [TUPLE]): ARRAYED_LIST [detachable ANY]
		local
			l_tuple: TUPLE
			l_arrayed_list: ARRAYED_LIST [detachable ANY]
		do
			l_tuple := csv_object_to_eiffel_tuple (a_key, a_list)
			create Result.make (l_tuple.count)
			across
				l_tuple as ic
			loop
				Result.force (ic.item)
			end
		end

	csv_object_to_eiffel_arrayed_list_attached (a_key: STRING; a_list: ARRAY [TUPLE]): ARRAYED_LIST [ANY]
		local
			l_tuple: TUPLE
			l_arrayed_list: ARRAYED_LIST [ANY]
		do
			l_tuple := csv_object_to_eiffel_tuple (a_key, a_list)
			create Result.make (l_tuple.count)
			across
				l_tuple as ic
			loop
				if attached ic.item as al_item then
					Result.force (al_item)
				end
			end
		end

	csv_object_to_eiffel_mixed (a_key: STRING; a_list: ARRAY [TUPLE]): FW_MIXED_NUMBER
		local
			l_tuple: TUPLE
			l_args: TUPLE [is_negative: BOOLEAN; whole, num, denom: INTEGER]
		do
			l_tuple := csv_object_to_eiffel_tuple (a_key, a_list)
			check has_four: l_tuple.count = 4 end
			check
				attached {BOOLEAN} l_tuple [1] as al_is_neg
					and then attached {INTEGER} l_tuple [2] as al_whole_int
					and then attached {INTEGER} l_tuple [3] as al_num_int
					and then attached {INTEGER} l_tuple [4] as al_denom_int
			then
				create Result.make (al_is_neg, al_whole_int.to_natural_64, al_num_int.to_natural_32, al_denom_int.to_natural_32)
			end
		end

	csv_object_to_eiffel_tuple (a_key: STRING; a_list: ARRAY [TUPLE]): TUPLE
		local
			l_result,
			l_tuple: TUPLE
			l_string: STRING
		do
			create Result
			create l_result
			if
				attached {TUPLE [ARRAY [TUPLE]]} tuple_for_key (a_key, a_list) as al_tuple_array_tuple
					and then attached {ARRAY [TUPLE]} al_tuple_array_tuple [1] as al_array_tuple
			then
				across
					al_array_tuple as ic
				loop
					check
						has: attached l_result
							and then attached {TUPLE} ic.item as al_tuple
					then
						if
							attached l_result
								and then not al_tuple.is_empty
								and then attached {STRING} al_tuple [1] as al_string
						then
							l_string := al_string.twin
							if not l_string.is_empty and then l_string [1] = '"' then
								l_string.remove_head (1)
								if not l_string.is_empty and then l_string [l_string.count] = '"' then
									l_string.remove_tail (1)
								end
								l_result := l_result + [l_string]
							elseif l_string.is_boolean then
								l_result := l_result + [l_string.to_boolean]
							elseif l_string.is_integer then
								l_result := l_result + [l_string.to_integer]
							elseif l_string.is_natural then
								l_result := l_result + [l_string.to_natural]
							elseif l_string.is_real then
								l_result := l_result + [l_string.to_real]
							else
								l_result := l_result + [l_string]
							end
						else
							l_result := l_result + al_tuple
						end
					end
				end
			end
			check has_tuple_result:
				attached l_result
			then
				Result := l_result
			end
		end

feature -- Converters: BOOLEAN

feature -- Converters: ARRAY

feature -- Converters: NULL

feature {TEST_SET_BRIDGE} -- Implementation: CORE

	tuple_for_key_attached (a_key: STRING; a_list: ARRAY [TUPLE]): TUPLE
		do
			check attached tuple_for_key (a_key, a_list) as al_tuple then Result := al_tuple end
		end

	tuple_for_key (a_key: STRING; a_list: ARRAY [TUPLE]): detachable TUPLE
		local
			i: INTEGER
		do
			i := convertible_feature_number (a_key)
			if (1 |..| a_list.count).has (i) then
				Result := a_list [i]
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation: STRING

	string_for_key_attached (a_key: STRING; a_list: ARRAY [TUPLE]): STRING
		do
			check attached string_for_key (a_key, a_list) as al_string then Result := al_string end
		end

	string_for_key (a_key: STRING; a_list: ARRAY [TUPLE]): detachable STRING
		do
			if attached tuple_for_key (a_key, a_list) as al_tuple and then attached {STRING} al_tuple [1] as al_string then
				Result := al_string
				Result.remove_head (1)
				Result.remove_tail (1)
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation

	convertible_feature_number (a_key: STRING): INTEGER
		do
			across
				convertible_features (Current) as ic
			from
				Result := 1
			until
				ic.item.same_string (a_key)
			loop
				Result := Result + 1
			end
		end

	csv_split (a_string: STRING): ARRAY [TUPLE]
		require
			balanced_square_brackets: a_string.occurrences ('[') = a_string.occurrences (']')
		local
			l_item: STRING
			l_result: ARRAYED_LIST [TUPLE]
			l_level: INTEGER
			l_is_iterating_down: BOOLEAN
			l_char: CHARACTER
		do
			across
				a_string as ic
			from
				create l_result.make (a_string.occurrences (','))
				create l_item.make_empty
				l_level := 0
				l_is_iterating_down := False
			loop
				l_char := ic.item
				inspect													-- each character in `a_string' ...
					ic.item
				when '[' then											-- '[' signals start of item, sub-item, array or tuple
					l_level := l_level + 1									-- Each subsequent '['  signals another level down
					l_is_iterating_down := True								-- From level #1 .. #n, we are always iterating down
				when ']' then											-- ']' signals end of item, sub-item, array or tuple
					l_level := l_level - 1									-- Each subsequence ']' signals another level back up
					if l_level = 0 and l_is_iterating_down then				-- When we return to level 0 + iterating, then ...
						l_result.force ([csv_split (l_item)])				-- Take the string we've built and make a sublevel TUPLE item
						create l_item.make_empty							-- Empty the text of our `l_item' because we're done with it
					end
				when ',' then											-- ',' signals the end of the item
					if l_level = 0 and not l_is_iterating_down then			-- If we were not iterating, then we save our TUPLE item
						l_result.force ([l_item])
						create l_item.make_empty
					elseif l_level > 0 and l_is_iterating_down then			-- These are our intermediate sub-item comma's
						l_item.append_character (ic.item)						-- So we save them in our string so we can pass them down ...
					elseif l_level = 0 and l_is_iterating_down then			-- If we were iterating down, then we can reset that flag
						l_is_iterating_down := False
					else
						check something_is_wrong: False end					-- Getting here ought to be impossible
					end
				else
					l_item.append_character (ic.item)
				end
			end
			if not l_item.is_empty then										-- Because there is no trailing comma to trigger saving our last item
				l_result.force ([l_item])										-- We do it here, but only if we have something to save
			end
			Result := l_result.to_array
		end

end
