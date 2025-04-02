#!/bin/bash

# Upgrade pip, setuptools, and wheel
pip install --upgrade pip setuptools wheel

# Install compatible versions of the packages
pip install importlib-metadata==7.0.0
pip install azureml-telemetry==1.57.0
pip install azure-storage-blob==12.19.0
pip install fsspec==2023.12.0
pip install sqlalchemy==1.4.45

# Install all required packages together
pip install mlflow-skinny==2.15.0 azureml-widgets==1.57.0 azureml-mlflow==1.57.0 adlfs==2024.7.0

pip install tensorflow==2.17.0 azureml-training-tabular==1.57.0 azureml-train-automl-runtime==1.57.0 azureml-datadrift==1.57.0 azureml-automl-runtime==1.57.0 azureml-automl-dnn-nlp==1.57.0
pip install --upgrade pandas==1.5.3 sqlalchemy==1.4.45
