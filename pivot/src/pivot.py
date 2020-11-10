import streamlit as st
import streamlit.components.v1 as components
import joblib
import os

from pivottablejs import pivot_ui

st.title('Data exploration: Bills of lading')


@st.cache(suppress_st_warning=True)
def load_data(file):
	df = joblib.load(file)
	return pivot_ui(df)


pvt = load_data(f"./data/{os.environ['STREAMLIT_DATA']}")

with open(pvt.src) as pivot:
	components.html(pivot.read(), width=1200, height=1000, scrolling=True)
