class
	TEST_TASK_OBJECT

inherit
	CSV_AWARE
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
			key.do_nothing
			name.do_nothing
			predecessors.do_nothing
			labor_type.do_nothing
			material_type.do_nothing
			uom.do_nothing
			est_qty.do_nothing
			est_qty_per_day.do_nothing
			est_qty_per_hour.do_nothing
			act_quantities.do_nothing
			cost_per_unit.do_nothing
		end

	make_from_csv_line (a_line: STRING)
		local
			l_list: ARRAY [TUPLE]
		do
			l_list := csv_split (a_line)
			project_key := csv_object_to_eiffel_string_attached ("project_key", l_list)
			key := csv_object_to_eiffel_string_attached ("key", l_list)
			name := csv_object_to_eiffel_string_attached ("name", l_list)
			if attached {ARRAYED_LIST [ANY]} csv_object_to_eiffel_arrayed_list_attached ("predecessors", l_list) as al_arrayed_list then
				create predecessors.make (al_arrayed_list.count)
				across
					al_arrayed_list as ic
				loop
					if attached {STRING} ic.item as al_item then
--						predecessors.force (al_item, al_item)
					end
				end
			end
			labor_type := csv_object_to_eiffel_string_attached ("labor_type", l_list)
			material_type := csv_object_to_eiffel_string_attached ("material_type", l_list)
			uom := csv_object_to_eiffel_string_attached ("uom", l_list)

			est_qty := csv_object_to_eiffel_decimal ("est_qty", l_list)
			est_qty_per_day := csv_object_to_eiffel_decimal ("est_qty_per_day", l_list)
			est_qty_per_hour := csv_object_to_eiffel_decimal ("est_qty_per_hour", l_list)
			if attached {ARRAYED_LIST [ANY]} csv_object_to_eiffel_arrayed_list_attached ("act_quantities", l_list) as al_arrayed_list then
				create act_quantities.make (al_arrayed_list.count)
				across
					al_arrayed_list as ic
				loop
					if attached {STRING} ic.item as al_item then
--						act_quantities.force (al_item, al_item)
					end
				end
			end
			cost_per_unit := csv_object_to_eiffel_decimal ("cost_per_unit", l_list)
		end

feature {NONE} -- Implementation

	convertible_features (a_object: ANY): ARRAY [STRING]
			-- <Precursor>
		once
			Result := <<
						"project_key",
						"key",
						"name",
						"predecessors",
						"labor_type",
						"material_type",
						"uom",
						"est_qty",
						"est_qty_per_day",
						"est_qty_per_hour",
						"act_quantities",
						"cost_per_unit"
					>>
		end

	prefix_string: STRING = "TASK"

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

	predecessors: ARRAYED_LIST [ANY]
			-- List of `predecessors' of Current.
		attribute
			create Result.make (5)
		end

	predecessors_key_list: STRING
		attribute
			create Result.make_empty
		end

	general_predecessors_key_list
		do
			create predecessors_key_list.make_empty
			across
				predecessors as ic
			loop
--				predecessors_key_list.append_string_general (ic.item.key)
				predecessors_key_list.append_character ('|')
			end
			if predecessors.count > 1 then
				predecessors_key_list.remove_tail (1)
			end
		end

	area: detachable ANY
			-- The `area' that Current works within.

feature -- Access: Resources

	labor_resource: detachable ANY
			-- Current's assigned or unassigned `labor_resource'.

	attached_labor_resource: attached like labor_resource
		do
			check attached labor_resource as al_resource then Result := al_resource end
		end

	labor_type: STRING
			-- Current's `labor_type'.
		note
			warning: "[
				Leaving labor empty means that no resource can
				perform the work, which leaves Current in a state
				of being `labor_resource' starved!
				]"
		attribute
			create Result.make_empty
		end

	material_resource: detachable ANY
			-- Current's assigned or unassigned `material_resource' (as a resource).

	attached_material_resource: attached like material_resource
		do
			check attached material_resource as al_resource then Result := al_resource end
		end

	material_type: STRING
			-- Current's `material_type'.
		note
			design: "[
				An empty `material_type' along with a detached
				`material_resource' means Current has no materials
				needed for `labor_resource' of `labor_type' to
				complete the work.
				
				However--if `material_resource' is provided (attached)
				then, an empty `material_type' means that no material
				will be chosen from the pool, which will leave Current
				to be `material_resource' starved!
				]"
		attribute
			create Result.make_empty
		end

feature -- Access: Quantity

	uom: STRING
			-- Current's `uom'.
		attribute
			create Result.make_empty
		end

	est_qty_per_hour: DECIMAL
			-- Current's `est_qty_per_hour'.
		attribute
			create Result.make_zero
		end

	est_qty_per_day: DECIMAL
			-- Current's `est_qty_per_day'.
		attribute
			create Result.make_zero
		end

	est_qty: DECIMAL
			-- Current's `est_qty'.
		attribute
			create Result.make_zero
		end

	act_quantities: ARRAYED_LIST [DECIMAL]
			-- List of `act_quantities'.
		attribute
			create Result.make (10)
		end

feature -- Access: Costs

	cost_per_unit: DECIMAL
			-- Current's `cost_per_unit'.
		attribute
			create Result.make_zero
		end

end
