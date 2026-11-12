
"""Visualization functions for the airline satisfaction project."""

import os
import matplotlib.pyplot as plt
import seaborn as sns


def setup_plot_style():
    """Set the default chart style."""
    sns.set_theme(style="whitegrid")
    plt.rcParams["figure.figsize"] = (10, 6)


def save_plot(file_name, output_dir="figures"):
    """Save the current chart and close it."""
    os.makedirs(output_dir, exist_ok=True)
    plt.tight_layout()
    plt.savefig(
        os.path.join(output_dir, file_name),
        dpi=300,
        bbox_inches="tight"
    )
    plt.close()


def plot_count(df, column, title, file_name):
    """Create a count plot for a categorical column."""
    plt.figure()
    sns.countplot(data=df, x=column)
    plt.title(title)
    plt.xticks(rotation=30)
    save_plot(file_name)


def plot_histogram(df, column, title, file_name):
    """Create a histogram for a numerical column."""
    plt.figure()
    sns.histplot(data=df, x=column, kde=True)
    plt.title(title)
    save_plot(file_name)


def plot_boxplot(df, column, category, title, file_name):
    """Compare a numerical column across categories."""
    plt.figure()
    sns.boxplot(data=df, x=category, y=column)
    plt.title(title)
    plt.xticks(rotation=30)
    save_plot(file_name)


def plot_bar(data, title, xlabel, ylabel, file_name):
    """Create a bar chart from a Series."""
    plt.figure()
    data.plot(kind="bar")
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.xticks(rotation=30)
    save_plot(file_name)


def plot_heatmap(data, title, file_name):
    """Create a correlation heatmap."""
    plt.figure(figsize=(12, 8))
    sns.heatmap(data, annot=True, cmap="coolwarm", fmt=".2f")
    plt.title(title)
    save_plot(file_name)
