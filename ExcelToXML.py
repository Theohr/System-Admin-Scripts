import xml.etree.ElementTree as ET
import pandas as pd
import xml.dom.minidom as md
import os

file_path = "C:\\Users\\T.Herodotou\\Downloads\\GOF2.1_Appraisal Trainings (1).xlsx"
sheets = pd.read_excel(file_path, sheet_name=None, dtype=object)
sheet_names = list(sheets.keys())[:8]


print("Column names in each sheet:")
for sheet_name in sheet_names:
    df = sheets[sheet_name]
    print(f"Sheet '{sheet_name}': {df.columns.tolist()}")

dfs = []
required_columns = ["AppraisalQuestionID", "AppraisalState", "ApplicableRank", "Training"]
for sheet in sheet_names:
    df = sheets[sheet]

    missing_cols = [col for col in required_columns if col not in df.columns]
    if missing_cols:
        print(f"Skipping sheet '{sheet}' due to missing columns: {missing_cols}")
        continue

    df = df[required_columns]
    dfs.append(df)


if not dfs:
    raise ValueError("No sheets contain all required columns: " + ", ".join(required_columns))


combined_df = pd.concat(dfs, ignore_index=True)


root = ET.Element('Trainings')
root.set('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')


for row in combined_df.itertuples():
    training = ET.SubElement(root, "Training")
    

    name = ET.SubElement(training, "Name")
    name.text = str(row.Training) if pd.notna(row.Training) else ""
    
    appraisal_state = ET.SubElement(training, "AppraisalState")
    appraisal_state.text = str(row.AppraisalState) if pd.notna(row.AppraisalState) else ""
    
    appraisal_item = ET.SubElement(training, "AppraisalItem")
    appraisal_item.text = str(row.AppraisalQuestionID) if pd.notna(row.AppraisalQuestionID) else ""
    
    rank = ET.SubElement(training, "Rank")
    rank.text = str(row.ApplicableRank) if pd.notna(row.ApplicableRank) else ""


output_file = "AppraisalTrainings.xml"
with open(output_file, "wb") as f:
    dom = md.parseString(ET.tostring(root))
    f.write(dom.toprettyxml(indent="  ").encode("utf-8"))

print(f"XML file has been generated: {output_file}")