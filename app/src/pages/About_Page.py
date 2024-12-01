import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
import streamlit_shadcn_ui as ui

from modules.nav import SideBarLinks

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()


with ui.card(key="card1", title="What is the co-op process?"):
    ui.element("span", children=["Northeastern University's co-op program integrates professional work with academic study, allowing students to gain hands-on experience, industry connections, and career clarity through six-month placements. Supported by thousands of employer partnerships, students can choose domestic, international, or research-focused co-ops with guidance on resume building and interview prep. This experiential learning model emphasizes applying academic knowledge to real-world challenges and encourages students to reflect on their experiences to enhance their personal and academic growth."], className="text-gray-400 text-md font-medium", key="content1")

with ui.card(key="card2", title="How does Co-op Connect help?"):
    ui.element("span", children=["A new data-driven co-op search platform created by students for students bridges the gap between students searching for co-ops and those who have completed them. Co-Op Connect tackles the hassle of navigating the co-op search process by creating a comprehensive, user-driven database of past interview questions and insider tips for each position. No more blind searches or cold emails—our real-time updates inform users of positions filled before their deadline to let you focus on open positions. Built for motivated students, recent graduates, and helpful alumni, Co-Op Connect also provides a recruiter network where both recruiters and previous interns can share insights about companies and roles. This cuts down time spent on lengthy research and empowers users with up-to-date, actionable intel. Co-Op Connect is here to make the path to co-op success easier, more informed, and infinitely more accessible."], className="text-gray-400 text-md font-medium", key="content2")
    

