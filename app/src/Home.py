##################################################
# This is the main/entry-point file for the 
# sample application for your project
##################################################
import streamlit_shadcn_ui as ui
# Set up basic logging infrastructure
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# import the main streamlit library as well
# as SideBarLinks function from src/modules folder
import streamlit as st
from modules.nav import SideBarLinks

# streamlit supports reguarl and wide layout (how the controls
# are organized/displayed on the screen).
st.set_page_config(layout = 'wide', page_title='Co-op Connect')


# If a user is at this page, we assume they are not 
# authenticated.  So we change the 'authenticated' value
# in the streamlit session_state to false. 
st.session_state['authenticated'] = False

# Use the SideBarLinks function from src/modules/nav.py to control
# the links displayed on the left-side panel. 
# IMPORTANT: ensure src/.streamlit/config.toml sets
# showSidebarNavigation = false in the [client] section
SideBarLinks(show_home=True)

# ***************************************************
#    The major content of this page
# ***************************************************

# set the title of the page and provide a simple prompt. 
logger.info("Loading the Home page of the app")
st.title('Co-op Connect')
st.write('\n\n')
st.write('### HI! As which user would you like to log in?')



# For each of the user personas for which we are implementing
# functionality, we put a button on the screen that the user 
# can click to MIMIC logging in as that mock user. 

if ui.button(text="Act as Maura Turner - CS Sophomore looking for her first co-op", key="maura_btn", className="bg-red-500 text-white w-full py-2 px-4 rounded-lg", use_container_width=True):
    # when user clicks the button, they are now considered authenticated
    st.session_state['authenticated'] = True
    # we set the role of the current user
    st.session_state['role'] = 'sophomore'
    # we add the first name of the user (so it can be displayed on 
    # subsequent pages). 
    st.session_state['first_name'] = 'Maura'
    # finally, we ask streamlit to switch to another page, in this case, the 
    # landing page for this particular user type
    logger.info("Logging in as Political Strategy Advisor Persona")
    st.switch_page('pages/12_API_Test.py')

if ui.button(text="Act as Wade Wilson - DS Senior looking to share his past co-op experiences and give advice", key="wade_btn", className="bg-red-500 text-white w-full py-2 px-4 rounded-lg", use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'senior'
    st.session_state['first_name'] = 'Wade'
    st.switch_page('pages/10_USAID_Worker_Home.py')

if ui.button(text="Act as Damian Wayne - recruiter at Microsoft looking to hire CS undergraduates", key="damian_btn", className="bg-red-500 text-white w-full py-2 px-4 rounded-lg", use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'recruiter'
    st.session_state['first_name'] = 'Damian'
    st.switch_page('pages/20_Admin_Home.py')

if ui.button(text="Act as Winston Churchill - Co-op advisor seeking to improve the whole process for students", key="winston_btn", className="bg-red-500 text-white w-full py-2 px-4 rounded-lg", use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'advisor'
    st.session_state['first_name'] = 'Winston'
    st.switch_page('pages/20_Admin_Home.py')



