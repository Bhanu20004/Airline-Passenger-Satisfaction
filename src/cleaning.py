
"""
Airline Passenger Satisfaction

Reusable functions for data cleaning and preprocessing.
"""

import pandas as pd


# Standardize column names

def standardize_column_names(df):
    """Convert column names to lowercase and standardize spaces."""

    df = df.copy()

    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    return df


# Remove unnecessary columns

def remove_unnecessary_columns(df, columns=None):
    """Remove selected unnecessary columns if they exist."""

    df = df.copy()

    if columns is None:
        columns = ["unnamed: 0", "id"]

    existing_columns = [
        column for column in columns
        if column in df.columns
    ]

    return df.drop(columns=existing_columns)


# Remove duplicate records

def remove_duplicates(df):
    """Remove completely duplicated rows."""

    df = df.copy()

    return df.drop_duplicates().reset_index(drop=True)


# Handle missing values

def missing_values_summary(df):
    """Return missing value counts and percentages."""

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


def handle_missing_values(df, strategy="median"):
    """
    Handle missing values in numerical and categorical columns.

    Numerical columns:
    - median: Replace missing values with median.
    - mean: Replace missing values with mean.

    Categorical columns:
    - Replace missing values with the most frequent value.
    """

    df = df.copy()

    numerical_columns = df.select_dtypes(
        include="number"
    ).columns

    categorical_columns = df.select_dtypes(
        include=["object", "category"]
    ).columns

    for column in numerical_columns:

        if df[column].isnull().any():

            if strategy == "median":
                fill_value = df[column].median()

            elif strategy == "mean":
                fill_value = df[column].mean()

            else:
                raise ValueError(
                    "Strategy must be 'median' or 'mean'."
                )

            if pd.notna(fill_value):
                df[column] = df[column].fillna(fill_value)

    for column in categorical_columns:

        if df[column].isnull().any():

            mode_values = df[column].mode()

            if not mode_values.empty:
                df[column] = df[column].fillna(
                    mode_values.iloc[0]
                )

    return df


# Standardize categorical values

def clean_categorical_values(df):
    """Remove extra spaces and standardize text capitalization."""

    df = df.copy()

    categorical_columns = df.select_dtypes(
        include=["object", "category"]
    ).columns

    for column in categorical_columns:

        df[column] = (
            df[column]
            .astype("string")
            .str.strip()
            .str.lower()
        )

    return df


# Validate numerical data

def validate_age(df, minimum_age=0, maximum_age=100):
    """Replace ages outside the specified range with missing values."""

    df = df.copy()

    if "age" in df.columns:

        invalid_age = (
            (df["age"] < minimum_age) |
            (df["age"] > maximum_age)
        )

        df.loc[invalid_age, "age"] = pd.NA

    return df


def validate_flight_distance(df):
    """Replace negative flight distances with missing values."""

    df = df.copy()

    if "flight_distance" in df.columns:

        df.loc[
            df["flight_distance"] < 0,
            "flight_distance"
        ] = pd.NA

    return df


def validate_service_ratings(df, minimum=0, maximum=5):
    """Replace service ratings outside the valid range with missing values."""

    df = df.copy()

    service_columns = [
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

    for column in service_columns:

        if column in df.columns:

            invalid_rating = (
                (df[column] < minimum) |
                (df[column] > maximum)
            )

            df.loc[invalid_rating, column] = pd.NA

    return df


# Complete cleaning process

def clean_airline_data(df):
    """
    Apply the main cleaning steps to the airline dataset.

    Returns a cleaned copy of the DataFrame.
    """

    df = standardize_column_names(df)

    df = remove_unnecessary_columns(df)

    df = remove_duplicates(df)

    df = clean_categorical_values(df)

    df = validate_age(df)

    df = validate_flight_distance(df)

    df = validate_service_ratings(df)

    df = handle_missing_values(df, strategy="median")

    return df


# Save cleaned dataset

def save_cleaned_data(df, output_path):
    """Save the cleaned DataFrame as a CSV file."""

    df.to_csv(
        output_path,
        index=False
    )

    print(f"Cleaned dataset saved to: {output_path}")
