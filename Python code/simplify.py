"""
Remove lines that give problems to snowflake.
Tested with python 3.8.5 and pandas 1.4.0
"""
from zipfile import ZipFile
import numpy as np
import pandas as pd


def row_to_skip(row: pd.Series) -> bool:
    descr = row['Description']
    if pd.isnull(descr):
        return False
    if ',' in descr:
        return True
    return False


if __name__ == "__main__":
    in_fp = 'archive.zip'
    out_fp = 'upload.csv'
    dtypes = { "InvoiceNo": str,
            "StockCode": str,
            'Description': str,
            'Quantity': np.int32,
            'UnitPrice': np.float64,
            'CustomerID': str,
            'Country': str
    }
    stream = ZipFile(in_fp).open('data.csv', 'r')
    df = pd.read_csv(stream, encoding_errors='replace', dtype=dtypes)
    drop_rows = df.apply(func=row_to_skip, axis=1)
 
    print(drop_rows.head())

    # tilda because we don't want to select any of these rows
    df = df.loc[~drop_rows, :]
    
    """
    if you want to upload df using the GUI console,
    consider calling something df.head(2000) or dropping at least around 50% of the rows
    """
    df.to_csv(out_fp, index=False)
    print(f'File to upload available at {out_fp}')