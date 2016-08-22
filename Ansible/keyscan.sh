#!/bin/bash

ssh-keyscan $(cat names) >> ~/.ssh/known_hosts
