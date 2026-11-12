# Airline Passenger Satisfaction: Insights

**Dataset:** 129,880 passengers, 23 columns, no missing values after cleaning.

## Key Findings

### 1. Overall Satisfaction
Only **43.4%** of passengers are satisfied, while 56.6% are neutral or dissatisfied. The classes are reasonably balanced.

### 2. Travel Class
| Class | % Satisfied | Passengers |
|---|---|---|
| Business | 69.4% | 62,160 |
| Economy Plus | 24.6% | 9,411 |
| Economy | 18.8% | 58,309 |

Fewer than 1 in 5 Economy passengers is satisfied.

### 3. Type of Travel
| Type of Travel | % Satisfied |
|---|---|
| Business | 58.4% |
| Personal | 10.1% |

Business travelers in Business class reach 72.0% satisfaction, while personal travelers stay between 9% and 12% in every class. Upgrading the seat does not fix the experience for leisure passengers.

### 4. Customer Type
| Customer Type | % Satisfied |
|---|---|
| Returning | 47.8% |
| First-time | 24.0% |

Returning customers are twice as satisfied as first-timers. The gap is largest in Business class (74.6% vs 39.7%). Gender has almost no effect (Female 42.9%, Male 44.0%).

### 5. Delays
Departure and arrival delays are almost perfectly correlated (r = 0.96).

| Arrival Delay | % Satisfied |
|---|---|
| On time or early | 47.4% |
| 1-15 min | 41.2% |
| 16-60 min | 35.9% |
| 60+ min | 35.6% |

Delays reduce satisfaction, but the overall correlation is weak (about -0.06). Satisfaction levels off after 16 minutes of delay.

### 6. Service Ratings
Ratings of 0 were treated as "not applicable" and excluded.

| Service | Correlation with Satisfaction | Mean Rating |
|---|---|---|
| Online boarding | 0.57 | 3.33 |
| In-flight entertainment | 0.40 | 3.36 |
| In-flight wifi | 0.39 | 2.81 |
| Seat comfort | 0.35 | 3.44 |
| On-board service | 0.32 | 3.38 |
| Leg room | 0.32 | 3.37 |
| Cleanliness | 0.31 | 3.29 |
| Gate location | 0.00 | 2.98 |
| Arrival time convenience | -0.05 | 3.22 |

Online boarding is the strongest driver. Inflight wifi has the lowest average rating among the strong drivers. Gate location and time convenience have almost no relationship with satisfaction.

### 7. Age and Flight Distance
| Age Group | % Satisfied |
|---|---|
| 25 and under | 28.4% |
| 26-40 | 41.0% |
| 41-60 | 57.7% |
| 60+ | 20.8% |

Satisfaction peaks at ages 41-60 and is lowest for passengers over 60. Long flights (over 1,744 miles) have 68.4% satisfaction, compared with 33-39% for shorter flights.

## Business Recommendations

1. Prioritize Economy and personal-travel passengers, the largest and least satisfied group.
2. Improve the online boarding experience, the strongest driver of satisfaction.
3. Upgrade inflight wifi, which has a strong impact and the lowest rating.
4. Create a first-time flyer program to close the gap with returning customers.
5. Target passengers over 60 and under 25 with better service and accessibility.
6. Focus delay recovery on flights delayed by more than 15 minutes, but treat it as secondary to service quality.

## Limitations

- These findings show correlation, not causation.
- Class, travel purpose, and distance overlap heavily. A logistic regression or random forest would help isolate the independent effect of each factor.