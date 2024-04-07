# Use the official Anaconda image as a parent image
FROM continuumio/anaconda3

# Set the working directory in the container
WORKDIR /usr/src/app

# Install necessary OS utilities including unzip
RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install TensorFlow, pydotplus, and ensure Jupyter is installed
RUN conda install -c conda-forge tensorflow && \
    pip install pydotplus jupyter

# # Download the specified file using wget (alternative to curl in this context)
# RUN wget https://dw9ne0o7jcasn.cloudfront.net/ml/MLCourse.zip -O MLCourse.zip && \
#     unzip MLCourse.zip && \
#     rm MLCourse.zip
COPY source/MLCourse /usr/src/app/MLCourse

# Expose the port Jupyter Notebook will use
EXPOSE 8888
RUN pwd && \
    ls -lart
# Run Jupyter Notebook
CMD ["jupyter", "notebook", "--notebook-dir=/usr/src/app/MLCourse", "--NotebookApp.token=''", "--ip='*'", "--port=8888", "--no-browser", "--allow-root"]
