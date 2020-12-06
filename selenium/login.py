# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options  # as ChromeOptions, Options
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By
import logging


def login(user, password):
    # Create and configure logger
    logging.basicConfig(filename="login_log.log",
                        format='%(asctime)s %(message)s',
                        filemode='w')
    # Creating an object
    logger = logging.getLogger()
    # Setting the threshold of logger to DEBUG
    logger.setLevel(logging.DEBUG)
    print('Starting the browser...')
    logger.debug('Starting the browser...')
    # --uncomment when running in Azure DevOps.
    chromeOptions = Options()
    chromeOptions.headless = True
    driver = webdriver.Chrome(executable_path="C:/webdriver/chromedriver.exe", options=chromeOptions)

    print('Browser started successfully. Navigating to the demo page to login.')
    logger.debug('Browser started successfully. Navigating to the demo page to login.')
    # go to the page
    driver.get('https://www.saucedemo.com/')

    myuser = driver.find_element_by_id("user-name")
    mypassword = driver.find_element_by_id("password")
    myuser.send_keys(user)
    mypassword.send_keys(password)
    driver.find_element_by_id("login-button").click()
    if WebDriverWait(driver, 5).until(EC.presence_of_element_located((By.ID, "inventory_container"))):
        print('The Login was successful by the user name: ' + user)
        logger.debug('The Login was successful by the user name: ' + user)
    else:
        print('Your login was unsuccessful')
        logger.debug('Your login was unsuccessful')
        driver.close()
    btnAddList = driver.find_elements_by_css_selector("button[class='btn_primary btn_inventory']")
    # adding all products to the cart
    for element in btnAddList:
        element.click()
    print('adding all products to a cart')
    logger.debug('adding all products to a cart')

    # List of buttons of all products
    btnAddList = driver.find_elements_by_css_selector("button[class='btn_secondary btn_inventory']")
    # removing all products from the cart
    for element in btnAddList:
        element.click()
    print('removing all products from a cart')
    logger.debug('removing all products from a cart')
    driver.close()


login('standard_user', 'secret_sauce')
