-- Test of the function Attempt_convert_to_decimal21
-- Try to convert  different user-supplied numbers to the type DECIMAL(2,1) to get which ones can be converted correctly.
-- Useful for Q3 of the homework.


select
	0.945::DECIMAL(2,1) -- 0.9
	, 0.95::DECIMAL(2,1)  -- 1
	, 0.0::DECIMAL(2,1)   -- 0
	, 0.01::DECIMAL(2,1)  -- 0
	, 9.45::DECIMAL(2,1)  -- 9.5
	, 9.449::DECIMAL(2,1)  -- 9.4
	, 9.94::DECIMAL(2,1)  -- 9.9
	-- , 9.95::DECIMAL(2,1)  -- ERROR: numeric field overflow
	, -0.01::DECIMAL(2,1) -- 0 : ?column?
	, -0.1::DECIMAL(2,1) -- 0.1 : ?column?
	, -1::DECIMAL(2,1) -- -1
;


-- same thing, but made robust via the fn
select
	Attempt_convert_to_decimal21(0.945::DECIMAL) -- 0.9
	, Attempt_convert_to_decimal21(0.95)  -- 1
	, Attempt_convert_to_decimal21(0.0)   -- 0
	, Attempt_convert_to_decimal21(0.01)  -- 0
	, Attempt_convert_to_decimal21(9.45)  -- 9.5
	, Attempt_convert_to_decimal21(9.449)  -- 9.4
	, Attempt_convert_to_decimal21(9.94)  -- 9.9
	, Attempt_convert_to_decimal21(9.95) -- -1 (indicates that an overflow happened)
	, Attempt_convert_to_decimal21(-0.01) -- 0
	, Attempt_convert_to_decimal21(-0.1) -- -0.1
;

