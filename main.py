
"""Main execution file for the airline satisfaction project."""

from src.utils import load_data, check_data, save_data
from src.cleaning import clean_airline_data
from src.analysis import (
    dataset_overview,
    satisfaction_distribution,
    satisfaction_percentage,
    service_ratings_summary,
    delay_summary
)
from src.visualization import (
    setup_plot_style,
    plot_count,
    plot_bar
)


def main():

    raw_path = "data/raw/airline_passenger_satisfaction.csv"
    cleaned_path = "data/processed/cleaned_airline_data.csv"

    # Load dataset
    df = load_data(raw_path)
    print("\nOriginal Dataset")
    check_data(df)

    # Clean dataset
    cleaned_df = clean_airline_data(df)
    save_data(cleaned_df, cleaned_path)

    print("\nCleaned Dataset")
    check_data(cleaned_df)

    # Dataset overview
    print("\nDataset Overview")
    print(dataset_overview(cleaned_df))

    # Satisfaction analysis
    print("\nSatisfaction Distribution")
    print(satisfaction_distribution(cleaned_df))

    print("\nSatisfaction Percentage")
    print(satisfaction_percentage(cleaned_df))

    # Service quality analysis
    print("\nAverage Service Ratings")
    print(service_ratings_summary(cleaned_df))

    # Flight delay analysis
    print("\nFlight Delay Summary")
    print(delay_summary(cleaned_df))

    # Visualization setup
    setup_plot_style()

    plot_count(
        cleaned_df,
        "satisfaction",
        "Passenger Satisfaction Distribution",
        "01_overall_satisfaction.png"
    )

    plot_bar(
        service_ratings_summary(cleaned_df),
        "Average Airline Service Ratings",
        "Service Factors",
        "Average Rating",
        "09_average_service_ratings.png"
    )

    print("\nProject analysis completed successfully!")


if __name__ == "__main__":
    main()
