class
	CSV_NUMBER

inherit
	CSV_VALUE
		redefine
			is_equal,
			is_number
		end

create
	make_integer,
	make_natural,
	make_real,
	make_decimal,
	make_string

feature {NONE} -- initialization

	make_integer (an_argument: INTEGER_64)
			-- Initialize an instance of csv_NUMBER from the integer value of `an_argument'.
		do
			item := an_argument.out
			numeric_type := integer_type
		end

	make_natural (an_argument: NATURAL_64)
			-- Initialize an instance of csv_NUMBER from the unsigned integer value of `an_argument'.
		do
			item := an_argument.out
			numeric_type := natural_type
		end

	make_real (an_argument: REAL_64)
			-- Initialize an instance of csv_NUMBER from the floating point value of `an_argument'.
		do
			item := an_argument.out
			numeric_type := double_type
		end

	make_decimal (a_argument: DECIMAL)
		do
			item := a_argument.to_engineering_string
			numeric_type := double_type
		end

	make_string (a_string: STRING)
		require
			is_number: a_string.is_number_sequence
		do
			if a_string.is_integer then
				make_integer (a_string.to_integer)
			elseif a_string.is_natural then
				make_natural (a_string.to_natural)
			elseif a_string.is_real then
				make_real (a_string.to_real)
			else
				make_integer (a_string.to_integer)
			end
		end

feature -- Status report			

	is_number: BOOLEAN = True
			-- <Precursor>

feature -- Access

	item: STRING
			-- Content

	numeric_type: INTEGER
			-- Type of number (integer, natural or real).

	hash_code: INTEGER
			--Hash code value
		do
			Result := item.hash_code
		end

	representation: STRING
		do
			Result := item
		end

feature -- Conversion

	integer_64_item: INTEGER_64
			-- Associated integer value.
		require
			is_integer: is_integer
		do
			Result := item.to_integer_64
		end

	natural_64_item: NATURAL_64
			-- Associated natural value.
		require
			is_natural: is_natural
		do
			Result := item.to_natural_64
		end

	double_item, real_64_item: REAL_64
			-- Associated real value.
		require
			is_real: is_real
		do
			Result := item.to_real_64
		end

feature -- Status report

	is_integer: BOOLEAN
			-- Is Current an integer number?
		do
			Result := numeric_type = integer_type
		end

	is_natural: BOOLEAN
			-- Is Current a natural number?
		do
			Result := numeric_type = natural_type
		end

	is_double, is_real: BOOLEAN
			-- Is Current a real number?
		do
			Result := numeric_type = real_type
		end

feature -- Status

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object of the same type
			-- as current object and identical to it?
		do
			Result := item.is_equal (other.item)
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := item
		end

feature -- Implementation

	integer_type: INTEGER = 1

	double_type, real_type: INTEGER = 2

	natural_type: INTEGER = 3

invariant
	item_not_void: item /= Void

end
