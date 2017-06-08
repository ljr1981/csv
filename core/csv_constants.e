note
	description: "[
		Constants as they apply to CSV based on RFC 4180 Page 2 Item 7 ABNF
		]"
	EIS: "name=Common Format and MIME Type for Comma-Separated Values (CSV) Files", "protocol=URI", "src=https://tools.ietf.org/html/rfc4180"
	EIS: "name=RFC4180-Page-2", "protocol=URI", "src=https://tools.ietf.org/html/rfc4180#page-2"
	EIS: "name=WikiPedia", "protocol=URI", "src=https://en.wikipedia.org/wiki/Comma-separated_values"

	BNF: "[
	   The ABNF grammar [2] appears as follows:

	   file = [header CRLF] record *(CRLF record) [CRLF]

	   header = name *(COMMA name)

	   record = field *(COMMA field)

	   name = field

	   field = (escaped / non-escaped)

	   escaped = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE

	   non-escaped = *TEXTDATA

	   COMMA = %x2C

	   CR = %x0D ;as per section 6.1 of RFC 2234 [2]

	   DQUOTE =  %x22 ;as per section 6.1 of RFC 2234 [2]

	   LF = %x0A ;as per section 6.1 of RFC 2234 [2]

	   CRLF = CR LF ;as per section 6.1 of RFC 2234 [2]

	   TEXTDATA =  %x20-21 / %x23-2B / %x2D-7E

		]"

class
	CSV_CONSTANTS

feature -- Constants

	file_extension: STRING = "csv"

	cr: CHARACTER once create Result; Result.code.set_item (0x0D) end 				-- %x0D ;as per section 6.1 of RFC 2234 [2]
	lf: CHARACTER once create Result; Result.code.set_item (0x0A) end 				-- %x0A ;as per section 6.1 of RFC 2234 [2]
	crlf: STRING once Result := CR.out; Result.append_character (LF) end 			-- CR LF ;as per section 6.1 of RFC 2234 [2]

	comma: CHARACTER once create Result; Result.code.set_item (0x2C) end 			-- %x2C
	dquote: CHARACTER once create Result; Result.code.set_item (0x22) end 			-- %x22 ;as per section 6.1 of RFC 2234 [2]
	ddquote: STRING once Result := DQUOTE.out; Result.append_character (DQUOTE) end	--
	textdata: STRING																-- %x20-21 / %x23-2B / %x2D-7E
		local
			l_asc: ASCII
			l_char: CHARACTER
		once
			create Result.make_empty
			create l_char; l_char.code.set_item (0x20); Result.append_character (l_char)
			create l_char; l_char.code.set_item (0x21); Result.append_character (l_char)
			across 0x23 |..| 0x2B as ic loop
				create l_char; l_char.code.set_item (ic.item); Result.append_character (l_char)
			end
			across 0x2D |..| 0x7E as ic loop
				create l_char; l_char.code.set_item (ic.item); Result.append_character (l_char)
			end
		end

end
