from typing import Union, List, Dict
import os
import argparse
import logging

# Initialize logging
logging.basicConfig(level=logging.INFO)

# Define the directory structures
personal_directories = {
    "Trips": ["2024", "2023"],
    "Photos": ["2024", "2023"],
    "Documents": {
        "Personal": ["Financial", "Health"],
        "Work": [],
        "Trainings": [],
    },
    "Codes": {
        "Personal": [],
        "OpenSource": [],
    },
    "Games": [],
    "Softwares": [],
}

work_directories = {
    "Trips": ["2024", "2023"],
    "Documents": {
        "Trainings": [],
        "Work": [],
    },
    "Codes": {
        "Projects": [],
        "OpenSource": [],
    },
}


def parse_arguments() -> argparse.Namespace:
    """
    Parse command-line arguments.

    Returns:
        argparse.Namespace: Parsed arguments.
    """
    parser = argparse.ArgumentParser(description="Create directory structure.")
    parser.add_argument(
        "-d",
        "--directory_type",
        choices=["Work", "Personal"],
        required=True,
        help="Specify directory type (Work or Personal)",
    )
    parser.add_argument(
        "-b",
        "--base_directory",
        default=os.getcwd(),
        help="Specify base directory path (default is current working directory)",
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Enable verbose logging"
    )
    return parser.parse_args()


def sanitize_name(name: str) -> str:
    """
    Sanitize directory or file name by removing spaces, dots, and commas.

    Args:
        name (str): The name to sanitize.

    Returns:
        str: Sanitized name.
    """
    return name.replace(" ", "_").replace(".", "").replace(",", "")


def create_directory(path: str) -> None:
    """
    Create a directory if it does not exist.

    Args:
        path (str): Path of the directory to create.
    """
    try:
        if not os.path.exists(path):
            os.makedirs(path, 0o755)  # Set directory permissions to 755
            logging.info(f"Created directory: {path}")
        else:
            logging.warning(f"Directory '{path}' already exists!")
    except OSError as e:
        logging.error(f"Error creating directory {path}: {e}")


def create_directories(
    base_path: str, dirs: Dict[str, Union[str, List[str], Dict[str, List[str]]]]
) -> None:
    """
    Recursively create directories based on the provided structure.

    Args:
        base_path (str): The base directory path.
        dirs (Dict[str, Union[str, List[str], Dict[str, List[str]]]]): Directory structure to create.
    """
    for dir_name, sub_dirs in dirs.items():
        dir_name = sanitize_name(dir_name)
        dir_path = os.path.join(base_path, dir_name)
        create_directory(dir_path)

        if isinstance(sub_dirs, list):
            for sub_dir in sub_dirs:
                sub_dir_name = sanitize_name(sub_dir)
                sub_dir_path = os.path.join(dir_path, sub_dir_name)
                create_directory(sub_dir_path)
        elif isinstance(sub_dirs, dict):
            create_directories(dir_path, sub_dirs)


if __name__ == "__main__":
    # Parse command-line arguments
    args = parse_arguments()

    # Define base directory
    base_dir = args.base_directory

    directory_type = args.directory_type

    # Validate base directory
    if not os.path.isabs(base_dir):
        logging.error("Base directory path must be an absolute path.")
        exit(1)

    # Validate directory type
    if directory_type not in ["Work", "Personal"]:
        logging.error(
            "Invalid directory type. Please choose either 'Work' or 'Personal'."
        )
        exit(1)

    # Define directory structure based on argument
    directory_structure = (
        personal_directories if directory_type == "Personal" else work_directories
    )

    # Create directories
    create_directories(base_dir, directory_structure)
    logging.info(f"{directory_type} directory structure created successfully!")
