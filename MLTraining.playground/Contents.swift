import Foundation
import CreateML

// Path of training images directory
let trainingImagesDirectoryPath = URL(fileURLWithPath: "/Users/emma/Desktop/Training_Data")

// Train with parameters for 20 iterations and no augmentation options
let parameters = MLImageClassifier.ModelParameters(featureExtractor: .scenePrint(revision: 1),
                                                   validationData: nil,
                                                   maxIterations: 20,
                                                   augmentationOptions: [])

// Train the model with training images
let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingImagesDirectoryPath))

// Evaluating training & validation accuracies.
let trainingAccuracy = (1.0 - model.trainingMetrics.classificationError) * 100 // Result: 100%
let validationAccuracy = (1.0 - model.validationMetrics.classificationError) * 100 // Result: 100%

// Path of test images directory
let testImagesDirectoryPath = URL(fileURLWithPath: "/Users/emma/Desktop/Testing_Data")

// Evaluate the trained model
let evaluation = model.evaluation(on: .labeledDirectories(at: testImagesDirectoryPath))
let evaluationAccuracy = (1.0 - evaluation.classificationError) * 100

print("Evaluation Metrics: \(evaluation)\n")
print("Training Metrics: \(model.trainingMetrics)\n")
print("Validation Metrics: \(model.validationMetrics)\n")
print("Training Accuracy: \(trainingAccuracy)\n")
print("Evaluation Accuracy: \(evaluationAccuracy)\n")
print("Validation Accuracy: \(validationAccuracy)\n")

// Confusion matrix to see which labels were wrongly classified
let confusionMatrix = evaluation.confusion
print("Confusion matrix: \(confusionMatrix)")

// Add metadata
let metadata = MLModelMetadata(author: "Emma O'Keeffe",
                               shortDescription: "A model trained to classify fruit and vegetables", version: "3.0")

// Save the model
try model.write(to: URL(fileURLWithPath: "/Users/emma/Desktop/FoodModel3.mlmodel"), metadata: metadata)





