
"""Utility functions for the airline satisfaction project."""

import os
import pandas as pd


def load_data(file_path):
    """Load a CSV dataset."""
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    return pd.read_csv(file_path)


def save_data(df, file_path):
    """Save a DataFrame as a CSV file."""
    os.makedirs(os.path.dirname(file_path) or ".", exist_ok=True)
    df.to_csv(file_path, index=False)


def check_data(df):
    """Display basic dataset information."""
    print("Shape:", df.shape)
    print("\nMissing Values:\n", df.isnull().sum())
    print("\nDuplicate Rows:", df.duplicated().sum())

"""Utility functions for the airline satisfaction project."""

import os
import pandas as pd


def load_data(file_path):
    """Load a CSV dataset."""
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    return pd.read_csv(file_path)


def save_data(df, file_path):
    """Save a DataFrame as a CSV file."""
    os.makedirs(os.path.dirname(file_path) or ".", exist_ok=True)
    df.to_csv(file_path, index=False)


def check_data(df):
    """Display basic dataset information."""
    print("Shape:", df.shape)
    print("\nMissing Values:\n", df.isnull().sum())
    print("\nDuplicate Rows:", df.duplicated().sum())
