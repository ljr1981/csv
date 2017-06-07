class
	CSV_TEST_OBJECT

inherit
	CSV_SERIALIZABLE

feature -- Access

	my_string: STRING
		attribute
			create Result.make_empty
		end

feature {NONE} -- Implementation

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<
						"my_string"
					>>
		end

end
