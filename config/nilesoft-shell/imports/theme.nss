theme
{
	name = "modern"
	
	background
	{
		opacity = 100
		effect = 2
		gradient
		{
			enabled = true
			linear = [500, 100, -50, 0]
			stop = [
				[0.0, #101020, 100],
				[0.649, #101020, 100],
				[0.65, #1e1e2e, 100],
				[0.799, #1e1e2e, 100],
				[0.8, #3e3e4e, 100],
				[1.0, #3e3e4e, 100]
			]
		}
	}

	item
	{
		opacity = 100

		prefix = 1

		text
		{
			normal = #cdd6f4
			select = #cdd6f4
			normal-disabled = #a6adc8
			select-disabled = #a6adc8
		}

		back
		{
			select = #45475a
			select-disabled = #313244
		}
	}

	border
	{
		enabled = true
		size = 1
		color = #f5c2e7
		opacity = 100
		radius = 2
	}

	shadow
	{
		enabled = true
		size = 5
		opacity = 5
		color = #11111b
	}

	separator
	{
		size = 1
		color = #313244
	}

	symbol
	{
		normal = #f5c2e7
		select = #f5c2e7
		normal-disabled = #a6adc8
		select-disabled = #a6adc8
	}

	image
	{
		enabled = true
		color = [#cdd6f4, #f5c2e7, #1e1e2e]
	}
}