import numpy as np
import os


def generate_dataset(n_train=10000, n_test=2000, n_features=10, noise=0.1, seed=42):
    """Generate synthetic dataset y = sin(x0) + noise"""
    np.random.seed(seed)

    X_train = np.random.randn(n_features, n_train)
    y_train = np.sin(X_train[0:1, :]) + noise * np.random.randn(1, n_train)

    X_test = np.random.randn(n_features, n_test)
    y_test = np.sin(X_test[0:1, :]) + noise * np.random.randn(1, n_test)

    os.makedirs('data', exist_ok=True)
    np.save('data/X_train.npy', X_train)
    np.save('data/y_train.npy', y_train)
    np.save('data/X_test.npy', X_test)
    np.save('data/y_test.npy', y_test)

    print(f"Dataset created: {n_train} train, {n_test} test samples")
    return X_train, y_train, X_test, y_test


if __name__ == "__main__":
    generate_dataset()
