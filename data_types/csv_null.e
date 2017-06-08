class
	CSV_NULL

inherit
	CSV_VALUE
		redefine
			is_null
		end

feature -- Status report			

	is_null: BOOLEAN = True
			-- <Precursor>

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := null_value.hash_code
		end

feature -- Conversion		

	representation: STRING
		do
			Result := "null"
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := null_value
		end

feature {NONE} -- Implementation

	null_value: STRING = "null"

end
