# LLTM: A PyTorch C++/CUDA Extension

This project is an example of a C++/CUDA extension for PyTorch, demonstrating a custom Long Short-Term Memory (LLTM) cell. It utilizes CMake and Scikit-build for the build process.

## Installation

To install this package, navigate to the root directory of the project and run:

```bash
pip install .
```

This command will build the extension and install it into your current Python environment.

## Building from Source (Alternative)

If you prefer to build the project manually or for development purposes:

1.  Ensure you have the necessary build tools installed (CMake, a C++ compiler, and CUDA toolkit if GPU support is enabled).
2.  Install PyTorch and other Python dependencies.
3.  From the project root, you can typically build using:
    ```bash
    python setup.py build_ext --inplace
    ```
    or let `pip` handle the build process as shown in the Installation section.

## Usage

After installation, you should be able to import the `lltm` module in Python and use its functionalities.

```python
import lltm

# Example usage (refer to specific examples or documentation for details)
tensor1 = torch.randn(10, 20)
tensor2 = torch.randn(10, 20)
result = lltm.lltm_ext.add(tensor1, tensor2)
print(result)
```

For more detailed examples, please refer to the `examples/` directory (if available) or the project's source code.

## Requirements

*   Python (>=3.8 as specified in `pyproject.toml`)
*   PyTorch (>=1.8 as specified in CMake configuration)
*   CMake
*   A C++17 compatible compiler
*   (Optional) CUDA Toolkit for GPU support

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details (if one exists, otherwise you might want to add one).
