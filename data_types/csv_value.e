note
	description: "[
		CSV_VALUE represents a value in CSV. 
		        A value can be
		            * null: CSV_NULL (NONE)
		            * string: CSV_STRING
		            * number: CSV_NUMERIC (integer, natural, real, decimal)
		            * boolean: CSV_BOOLEAN
		            * date: CSV_DATE
		            * date-time: CSV_DATE_TIME
		            * array: CSV_ARRAY
		            * object: CSV_OBJECT
	]"
	license: "MIT (see http://www.opensource.org/licenses/mit-license.php)"
	EIS: "name=Common Format and MIME Type for Comma-Separated Values (CSV) Files", "protocol=URI", "src=https://tools.ietf.org/html/rfc4180"
	EIS: "name=RFC4180-Page-2", "protocol=URI", "src=https://tools.ietf.org/html/rfc4180#page-2"

deferred class
	CSV_VALUE

inherit
	HASHABLE

	DEBUG_OUTPUT

feature -- Status report

	is_string: BOOLEAN
			-- * string: CSV_STRING
		do
		end

	is_number: BOOLEAN
			-- * number: CSV_NUMERIC
		do
		end

	is_boolean: BOOLEAN
			-- * boolean: CSV_BOOLEAN
		do
		end

	is_date: BOOLEAN
			-- * date: CSV_DATE
		do
		end

	is_date_time: BOOLEAN
			-- * date-time: CSV_DATE_TIME
		do
		end

	is_array: BOOLEAN
			-- * array: CSV_ARRAY
		do
		end


	is_object: BOOLEAN
			-- * object: CSV_OBJECT
		do
		end

	is_null: BOOLEAN
			-- * null: CSV_NULL
		do
		end

feature -- Access

	representation: STRING
			-- UTF-8 encoded Unicode string representation of Current
		deferred
		end

end
