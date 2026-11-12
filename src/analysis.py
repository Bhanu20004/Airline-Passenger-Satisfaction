
"""
Airline Passenger Satisfaction

Reusable functions for exploratory data analysis,
passenger demographics, travel patterns, delays,
customer satisfaction, and service quality.
"""

import pandas as pd


# Service columns used in the dataset

SERVICE_COLUMNS = [
    "departure_and_arrival_time_convenience",
    "ease_of_online_booking",
    "check-in_service",
    "online_boarding",
    "gate_location",
    "on-board_service",
    "seat_comfort",
    "leg_room_service",
    "cleanliness",
    "food_and_drink",
    "in-flight_service",
    "in-flight_wifi_service",
    "in-flight_entertainment",
    "baggage_handling"
]


# Dataset overview

def dataset_overview(df):
    """Return basic information about the dataset."""

    return {
        "total_records": len(df),
        "total_columns": len(df.columns),
        "numerical_columns": len(
            df.select_dtypes(include="number").columns
        ),
        "categorical_columns": len(
            df.select_dtypes(include="object").columns
        )
    }


# Data quality analysis

def missing_values_summary(df):
    """Calculate missing values and their percentages."""

    missing = pd.DataFrame({
        "missing_count": df.isnull().sum(),
        "missing_percentage": (
            df.isnull().mean() * 100
        ).round(2)
    })

    return missing.sort_values(
        by="missing_count",
        ascending=False
    )


def duplicate_count(df):
    """Return the number of duplicate rows."""

    return df.duplicated().sum()


# Numerical and categorical analysis

def numerical_summary(df):
    """Generate descriptive statistics for numerical columns."""

    return df.select_dtypes(
        include="number"
    ).describe().T


def categorical_summary(df):
    """Generate descriptive statistics for categorical columns."""

    return df.select_dtypes(
        include="object"
    ).describe().T


# Passenger demographics

def gender_distribution(df):
    """Calculate passenger distribution by gender."""

    return df["gender"].value_counts()


def customer_type_distribution(df):
    """Calculate passenger distribution by customer type."""

    return df["customer_type"].value_counts()


def age_statistics(df):
    """Calculate passenger age statistics."""

    return {
        "average_age": round(df["age"].mean(), 2),
        "median_age": df["age"].median(),
        "minimum_age": df["age"].min(),
        "maximum_age": df["age"].max()
    }


def age_group_distribution(df):
    """Group passengers into age categories."""

    age_bins = [0, 25, 35, 45, 55, 65, 100]

    age_labels = [
        "18-25",
        "26-35",
        "36-45",
        "46-55",
        "56-65",
        "66+"
    ]

    age_groups = pd.cut(
        df["age"],
        bins=age_bins,
        labels=age_labels
    )

    return age_groups.value_counts().sort_index()


# Travel characteristics

def travel_type_distribution(df):
    """Calculate passenger distribution by travel purpose."""

    return df["type_of_travel"].value_counts()


def travel_class_distribution(df):
    """Calculate passenger distribution by travel class."""

    return df["class"].value_counts()


def flight_distance_summary(df):
    """Calculate flight distance statistics."""

    return {
        "average_distance": round(
            df["flight_distance"].mean(), 2
        ),
        "median_distance": df["flight_distance"].median(),
        "shortest_distance": df["flight_distance"].min(),
        "longest_distance": df["flight_distance"].max()
    }


def distance_by_class(df):
    """Compare flight distances across travel classes."""

    return df.groupby("class")["flight_distance"].agg(
        ["count", "mean", "median", "min", "max"]
    ).round(2)


# Flight delay analysis

def delay_summary(df):
    """Calculate departure and arrival delay statistics."""

    return df[
        ["departure_delay", "arrival_delay"]
    ].describe().T


def delayed_passenger_summary(df):
    """Calculate the number and percentage of delayed passengers."""

    total = len(df)

    if total == 0:
        return pd.DataFrame()

    departure_delayed = (
        df["departure_delay"] > 0
    ).sum()

    arrival_delayed = (
        df["arrival_delay"] > 0
    ).sum()

    return pd.DataFrame({
        "delay_type": [
            "Departure Delay",
            "Arrival Delay"
        ],
        "passenger_count": [
            departure_delayed,
            arrival_delayed
        ],
        "percentage": [
            round(departure_delayed / total * 100, 2),
            round(arrival_delayed / total * 100, 2)
        ]
    })


def delay_by_satisfaction(df):
    """Compare average flight delays by satisfaction level."""

    return df.groupby("satisfaction")[
        ["departure_delay", "arrival_delay"]
    ].mean().round(2)


# Customer satisfaction analysis

def satisfaction_distribution(df):
    """Calculate overall passenger satisfaction distribution."""

    return df["satisfaction"].value_counts()


def satisfaction_percentage(df):
    """Calculate satisfaction distribution in percentages."""

    return (
        df["satisfaction"]
        .value_counts(normalize=True)
        .mul(100)
        .round(2)
    )


def satisfaction_by_category(df, category):
    """Compare satisfaction across a selected category."""

    return pd.crosstab(
        df[category],
        df["satisfaction"],
        normalize="index"
    ).mul(100).round(2)


def satisfaction_by_age_group(df):
    """Calculate satisfaction percentages by age group."""

    age_bins = [0, 25, 35, 45, 55, 65, 100]

    age_labels = [
        "18-25",
        "26-35",
        "36-45",
        "46-55",
        "56-65",
        "66+"
    ]

    age_groups = pd.cut(
        df["age"],
        bins=age_bins,
        labels=age_labels
    )

    result = pd.crosstab(
        age_groups,
        df["satisfaction"],
        normalize="index"
    ) * 100

    return result.round(2)


# Airline service quality analysis

def service_ratings_summary(df):
    """Calculate average ratings for airline service factors."""

    available_columns = [
        column for column in SERVICE_COLUMNS
        if column in df.columns
    ]

    if not available_columns:
        raise ValueError(
            "No matching service columns found in the dataset."
        )

    return (
        df[available_columns]
        .mean()
        .sort_values(ascending=False)
        .round(2)
    )


def service_ratings_by_satisfaction(df):
    """Compare average service ratings by satisfaction level."""

    available_columns = [
        column for column in SERVICE_COLUMNS
        if column in df.columns
    ]

    if not available_columns:
        raise ValueError(
            "No matching service columns found in the dataset."
        )

    return df.groupby("satisfaction")[
        available_columns
    ].mean().T.round(2)


# Business analysis

def satisfaction_by_class_and_customer(df):
    """Analyze satisfaction by travel class and customer type."""

    return pd.crosstab(
        [
            df["class"],
            df["customer_type"]
        ],
        df["satisfaction"]
    )


def long_delay_analysis(df, threshold=30):
    """Analyze passengers experiencing delays above a threshold."""

    delayed = df[
        (df["departure_delay"] > threshold) |
        (df["arrival_delay"] > threshold)
    ]

    return delayed.groupby("satisfaction").agg(
        passenger_count=("satisfaction", "count"),
        average_departure_delay=("departure_delay", "mean"),
        average_arrival_delay=("arrival_delay", "mean")
    ).round(2)
