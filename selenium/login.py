# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
# from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By

# create an instance of Chrome driver
driver = webdriver.Chrome('C:/webdriver/chromedriver.exe')


def login(user, password):
    print('Starting the browser...')
    # --uncomment when running in Azure DevOps.
    # options = ChromeOptions()
    # options.add_argument("--headless")
    # driver = webdriver.Chrome(options=options)
    print('Browser started successfully. Navigating to the demo page to login.')
    # go to the page
    driver.get('https://www.saucedemo.com/')
    driver.maximize_window()
    myuser = driver.find_element_by_id("user-name")
    mypassword = driver.find_element_by_id("password")
    myuser.send_keys(user)
    mypassword.send_keys(password)
    driver.find_element_by_id("login-button").click()
    if WebDriverWait(driver, 5).until(EC.presence_of_element_located((By.ID, "inventory_container"))):
        print('The Login was successful by the user name: ' + user)
    else:
        print('Your login was unsuccessful')
        driver.close()


login('standard_user', 'secret_sauce')

# List of buttons of all products
btnAddList = driver.find_elements_by_css_selector("button[class='btn_primary btn_inventory']")
# adding all products to the cart
for element in btnAddList:
    element.click()
print('adding all products to a cart')

# List of buttons of all products
btnAddList = driver.find_elements_by_css_selector("button[class='btn_secondary btn_inventory']")
# removing all products from the cart
for element in btnAddList:
    element.click()
print('removing all products from a cart')

driver.close()
