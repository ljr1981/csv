deferred class
	CSV_DESERIALIZABLE

inherit
	CSV_TRANSFORMABLE

feature {NONE} -- Initialization

	make_from_csv_line (a_csv_line: STRING)
		deferred
		end

feature -- Operations

	csv_object_to_eiffel_string (a_key: STRING; a_csv_line: STRING): detachable STRING
		do
			Result := string_for_key (a_key, csv_split (a_csv_line))
		end

	csv_object_to_eiffel_string_attached (a_key: STRING; a_csv_line: STRING): STRING
		do
			Result := string_for_key_attached (a_key, csv_split (a_csv_line))
		end

feature {TEST_SET_BRIDGE} -- Implementation

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

	tuple_for_key_attached (a_key: STRING; a_list: ARRAY [TUPLE]): TUPLE
		do
			check attached tuple_for_key (a_key, a_list) as al_tuple then Result := al_tuple end
		end

	tuple_for_key (a_key: STRING; a_list: ARRAY [TUPLE]): detachable TUPLE
		local
			l_list: ARRAY [TUPLE]
			i: INTEGER
		do
			i := convertible_feature_number (a_key)
			if (1 |..| a_list.count).has (i) then
				Result := a_list [i]
			end
		end

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
		local
			l_item: STRING
			l_result: ARRAYED_LIST [TUPLE]
			l_level: INTEGER
			l_is_iterating_down: BOOLEAN
		do
			across
				a_string as ic
			from
				create l_result.make (a_string.occurrences (','))
				create l_item.make_empty
				l_level := 0
				l_is_iterating_down := False
			loop
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
