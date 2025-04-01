#!/bin/bash

# Upgrade pip, setuptools, and wheel
pip install --upgrade pip setuptools wheel

# Install compatible versions of the packages
pip install importlib-metadata==7.0.0
pip install azureml-telemetry==1.57.0
pip install azure-storage-blob==12.19.0
pip install fsspec==2023.12.0

# Install all required packages together
pip install mlflow-skinny==2.15.0 azureml-widgets==1.57.0 azureml-mlflow==1.57.0 adlfs==2024.7.0
