class
	CSV_DATE

inherit
	CSV_VALUE

create
	make_from_yyyymmdd,
	make,
	make_from_date,
	make_month_day_year,
	make_now,
	make_now_utc,
	make_by_days,
	make_from_string_default,
	make_from_string_default_with_base,
	make_from_string,
	make_from_string_with_base

feature {NONE} -- Initialization

	make_from_yyyymmdd (a_yyyymmdd: STRING)
		require
			length_8: a_yyyymmdd.count = 8
			integer: a_yyyymmdd.is_integer
			positive: a_yyyymmdd.to_integer > 0
		do
			create item.make (a_yyyymmdd.substring (1, 4).to_integer, a_yyyymmdd.substring (5, 6).to_integer, a_yyyymmdd.substring (7, 8).to_integer)
		end

	make (y, m, d: INTEGER)
			-- Set `year', `month' and `day' to `y', `m', `d' respectively.
		do
			create item.make (y, m, d)
		end

	make_from_date (a_date: DATE)
		do
			create item.make (a_date.year, a_date.month, a_date.day)
		end

	make_month_day_year (m, d, y: INTEGER)
			-- Set `month', `day' and `year' to `m', `d' and `y' respectively.
		do
			create item.make (y, m, d)
		end

	make_day_month_year (d, m, y: INTEGER)
			-- Set `day', `month' and `year' to `d', `m' and `y' respectively.
		do
			create item.make (y, m, d)
		end

	make_now
			-- Set the current object to today's date.
		do
			create item.make_now
		end

	make_now_utc
			-- Set the current object to today's date in utc format.
		local
			l_date: C_DATE
		do
			create l_date.make_utc
			make (l_date.year_now, l_date.month_now, l_date.day_now)
		end

	make_by_days (n: INTEGER)
			-- Set the current date with the number of days `n' since `origin'.
		do
			create item.make_by_days (n)
		end

	make_from_string_default (s: STRING)
			-- Initialize from a "standard" string of form
			-- `date_default_format_string'.
			-- (For 2-digit year specifications, the current century is used as
			-- base century.)
		do
			create item.make_from_string_default (s)
		end

	make_from_string_default_with_base (s: STRING; base: INTEGER)
			-- Initialize from a "standard" string of form
			-- `date_default_format_string' with base century `base'.
		do
			create item.make_from_string_default_with_base (s, base)
		end

	make_from_string (s: STRING; code: STRING)
			-- Initialize from a "standard" string of form
			-- `code'.
			-- (For 2-digit year specifications, the current century is used as
			-- base century.)
		local
			date: DATE
		do
			date := (create {DATE_TIME_CODE_STRING}.make (code)).create_date (s)
			create item.make (date.year, date.month, date.day)
		end

	make_from_string_with_base (s: STRING; code: STRING; base: INTEGER)
			-- Initialize from a "standard" string of form
			-- `code' with base century `base'.
		local
			code_string: DATE_TIME_CODE_STRING
			date: DATE
		do
			create code_string.make (code)
			code_string.set_base_century (base)
			date := code_string.create_date (s)
			create item.make (date.year, date.month, date.day)
		end

feature -- Access

	item: DATE

	hash_code: INTEGER
			-- Hash code value
		do
			Result := item.out.hash_code
		end

	representation: STRING
		do
			Result := item.out
		end

feature -- Status report

	debug_output: STRING
			-- Printable representation of `Current' with "standard"
			-- Form: `date_default_format_string'
		do
			Result := item.out
		end

end
