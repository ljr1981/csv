class
	CSV_BOOLEAN

inherit
	CSV_VALUE
	
create
	make,
	make_true, make_false,
	make_boolean

feature {NONE} -- Initialization

	make (a_value: BOOLEAN)
			-- Initialize Current csv boolean with `a_boolean'.
		do
			item := a_value
		end

	make_true
			-- Initialize Current csv boolean with True.
		do
			make (True)
		end

	make_false
			-- Initialize Current csv boolean with False.
		do
			make (False)
		end

	make_boolean (a_item: BOOLEAN)
			-- Initialize.
		obsolete
			"Use `make' [2017-05-31]"
		do
			make (a_item)
		end

feature -- Access

	item: BOOLEAN
			-- Content

	hash_code: INTEGER
			-- Hash code value
		do
			Result := item.hash_code
		end

	representation: STRING
		do
			if item then
				Result := "true"
			else
				Result := "false"
			end
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := item.out
		end

end
