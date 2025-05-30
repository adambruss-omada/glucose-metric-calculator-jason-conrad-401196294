- need to have a dashboard with the following metrics
    - average glucose level
        - the last 7 days
        - current calendar month
    - time below the average
        - the last 7 days
        - current calendar month
    - Time above the average
        - the last 7 days
        - current calendar month
    - All based off of the tested_at time
    - should also compare it to the previous month

    For the time being I'm not tying worrying about the member for glucose levels as there is only one member **eventually would only pull back the glucose_readings for the specific member using the belongs_to/has_many relationship I set up** ie `member.glucose_levels`






**Notes on refactors and changes I'd make**
- `days_in_month` is dependent on the arguement being an integer representation of the month ie May is the fifth month so the arguement would need to be 5, would want to handle that and ensure that either 
    a) The call is only ever sending that over or
    b) The month related methods had logic to handle if the Month name is sent over
