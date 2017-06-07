class
	CSV_ARRAY

inherit
	CSV_VALUE
		redefine
			is_array
		end

	ITERABLE [CSV_VALUE]

	DEBUG_OUTPUT

create
	make, make_empty,
	make_array

feature {NONE} -- Initialization

	make (nb: INTEGER)
			-- Initialize CSV_ array with capacity of `nb' items.
		do
			create items.make (nb)
		end

	make_empty
			-- Initialize empty CSV_ array.
		do
			make (0)
		end

	make_array
			-- Initialize CSV_ Array
		obsolete
			"Use `make' [2017-05-31]"
		do
			make (10)
		end

feature -- Status report			

	is_array: BOOLEAN = True
			-- <Precursor>

feature -- Access

	i_th alias "[]" (i: INTEGER): CSV_VALUE
			-- Item at `i'-th position
		require
			is_valid_index: valid_index (i)
		do
			Result := items.i_th (i)
		end

	representation: STRING
		do
			Result := "["
			across
				items as ic
			loop
				if Result.count > 1 then
					Result.append_character (',')
				end
				Result.append (ic.item.representation)
			end
			Result.append_character (']')
		end

feature -- Access

	new_cursor: ITERATION_CURSOR [CSV_VALUE]
			-- Fresh cursor associated with current structure
		do
			Result := items.new_cursor
		end

feature -- Mesurement

	count: INTEGER
			-- Number of items.
		do
			Result := items.count
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result := (1 <= i) and (i <= count)
		end

feature -- Change Element

	put_front (v: CSV_VALUE)
		require
			v_not_void: v /= Void
		do
			items.put_front (v)
		ensure
			has_new_value: old items.count + 1 = items.count and items.first = v
		end

	add, extend (v: CSV_VALUE)
		require
			v_not_void: v /= Void
		do
			items.extend (v)
		ensure
			has_new_value: old items.count + 1 = items.count and items.has (v)
		end

	prune_all (v: CSV_VALUE)
			-- Remove all occurrences of `v'.
		require
			v_not_void: v /= Void
		do
			items.prune_all (v)
		ensure
			not_has_new_value: not items.has (v)
		end

	wipe_out
			-- Remove all items.
		do
			items.wipe_out
 		end

feature -- Report

	hash_code: INTEGER
			-- Hash code value
		local
			l_started: BOOLEAN
		do
			across
				items as ic
			loop
				if l_started then
					Result := ((Result \\ 8388593) |<< 8) + ic.item.hash_code
				else
					Result := ic.item.hash_code
					l_started := True
				end
			end
			Result := Result \\ items.count
		end

feature -- Conversion

	array_representation: ARRAYED_LIST [CSV_VALUE]
			-- Representation as a sequences of values.
			-- be careful, modifying the return object may have impact on the original CSV_ARRAY object.		
		do
			Result := items
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := count.out + " item(s)"
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [CSV_VALUE]
			-- Value container

invariant
	items_not_void: items /= Void

end
