class
	TEST_RESOURCE_OBJECT

inherit
	CSV_AWARE
		rename
			representation_from_current as csv_representation
		redefine
			default_create
		end

create
	default_create,
	make_from_csv_line

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			project_key.do_nothing
			key.do_nothing
			name.do_nothing
			spec.do_nothing
			cubic_feet.do_nothing
			cost_fixed.do_nothing
			cost_per_hour.do_nothing
			cost_to_purchase.do_nothing
			uom.do_nothing
		end

	make_from_csv_line (a_line: STRING)
		local
			l_list: ARRAY [TUPLE]
		do
			l_list := csv_split (a_line)
			project_key := csv_object_to_eiffel_string_attached ("project_key", l_list)
			key := csv_object_to_eiffel_string_attached ("key", l_list)
			name := csv_object_to_eiffel_string_attached ("name", l_list)
			if attached {ARRAYED_LIST [ANY]} csv_object_to_eiffel_arrayed_list_attached ("types", l_list) as al_arrayed_list then
				create types_hash.make (al_arrayed_list.count)
				across
					al_arrayed_list as ic
				loop
					if attached {STRING} ic.item as al_item then
						types_hash.force (al_item, al_item)
					end
				end
			end
			spec := csv_object_to_eiffel_string_attached ("spec", l_list)
			cost_fixed := csv_object_to_eiffel_decimal ("cost_fixed", l_list)
			cost_per_hour := csv_object_to_eiffel_decimal ("cost_per_hour", l_list)
			cost_to_purchase := csv_object_to_eiffel_decimal ("cost_to_purchase", l_list)
			cubic_feet := csv_object_to_eiffel_integer ("cubic_feet", l_list)
			uom := csv_object_to_eiffel_string_attached ("uom", l_list)
		end

feature {NONE} -- Implementation

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<
						"project_key",
						"key",
						"name",
						"types",
						"spec",
						"cubic_feet",
						"cost_fixed",
						"cost_per_hour",
						"cost_to_purchase",
						"uom"
					>>
		end

	prefix_string: STRING = "RESOURCE"

feature -- Access: Project

	project_key: STRING
		attribute
			create Result.make_empty
		end

	is_template: BOOLEAN
		do
			Result := project_key.is_empty
		end

	set_project_key (a_project_key: like project_key)
			-- `set_project_key' to `a_project_key'.
		do
			project_key := a_project_key
		ensure
			set: project_key.same_string (a_project_key)
		end

feature -- Access

	key: STRING
			-- Current's `key'.
		attribute
			create Result.make_empty
		end

	name: STRING
			-- Current's `name'.
		attribute
			create Result.make_empty
		end

	spec: STRING
			-- Current's `spec'.
		attribute
			Result := "<><JAN-DEC><WEEKDAYS><0800-1700><>"
		end

	types_hash: HASH_TABLE [STRING, STRING]
			-- List of `types' covered by Current.
		attribute
			create Result.make (10)
		end

	types: ARRAYED_LIST [STRING]
		attribute
			create Result.make (10)
		end

	generate_types
		do
			types.wipe_out
			across
				types_hash as ic
			loop
				types.force (ic.item)
			end
		end

	types_pipe_string: STRING
		do
			create Result.make_empty
			across
				types as ic
			loop
				Result.append_string_general (ic.item)
				Result.append_character ('|')
			end
			if not Result.is_empty then
				Result.remove_tail (1)
			end
		end

	uom: STRING
			-- Unit of measure, where quantity is presumed to always be 1
		attribute
			Result := "EACH"
		end

feature -- Access: Area

	cubic_feet: DECIMAL
			-- Current's `cubic_feet'.
		attribute
			create Result.make_zero
		end

feature -- Access: Costs

	cost_per_hour: DECIMAL
			-- Current's `cost_per_hour'.
		attribute
			create Result.make_zero
		end

	cost_fixed: DECIMAL
			-- Current's `cost_fixed'.
		attribute
			create Result.make_zero
		end

	cost_to_purchase: DECIMAL
			-- Current's `cost_to_purchase'.
		attribute
			create Result.make_zero
		end

end
