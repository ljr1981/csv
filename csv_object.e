class
	CSV_OBJECT

inherit
	CSV_VALUE

	TABLE_ITERABLE [CSV_VALUE, CSV_STRING]

feature

	put (a_value: detachable CSV_VALUE; a_key: CSV_STRING)
			-- Assuming there is no item of key `a_key',
			-- insert `a_value' with `a_key'.
		require
			a_key_not_present: not has_key (a_key)
		do
			if a_value = Void then
				items.extend (create {CSV_NULL}, a_key)
			else
				items.extend (a_value, a_key)
			end
		end

	representation: STRING
			-- <Precursor>
		do
			create Result.make (2)
--			Result.append_character ('{')
			across
				items as ic
			loop
				if Result.count > 1 then
					Result.append_character (',')
				end
--				Result.append (ic.key.representation)
--				Result.append_character (':')
				Result.append (ic.item.representation)
			end
--			Result.append_character ('}')
		end


	hash_code: INTEGER

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := null_value
		end

feature {NONE} -- Implementation

	null_value: STRING = "null"

feature {NONE} -- Implementation

	items: HASH_TABLE [CSV_VALUE, CSV_STRING]
			-- Value container
		attribute
			create Result.make (0)
		end

feature -- Status report

	has_key (a_key: CSV_STRING): BOOLEAN
			-- has the CSV_OBJECT contains a specific key `a_key'.
		do
			Result := items.has (a_key)
		end

	has_item (a_value: CSV_VALUE): BOOLEAN
			-- has the CSV_OBJECT contain a specfic item `a_value'
		do
			Result := items.has_item (a_value)
		end

feature -- Access

	new_cursor: TABLE_ITERATION_CURSOR [CSV_VALUE, CSV_STRING]
			-- Fresh cursor associated with current structure
		do
			Result := items.new_cursor
		end

end
