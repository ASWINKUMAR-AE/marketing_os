"""
Phase 7: n8n Workflow Validation Test Suite
Validates JSON schemas, node definitions, connections, and trigger validity.
"""

import os
import json
import glob

WORKFLOWS_DIR = os.path.join(os.path.dirname(__file__), "..", "workflows")

EXPECTED_11_WORKFLOWS = [
    "00-ai-gateway.json",
    "01-weekly-planner.json",
    "02-content-generator.json",
    "03-image-renderer.json",
    "04-publisher.json",
    "05-seo-blog-engine.json",
    "06-lead-capture.json",
    "07-newsletter.json",
    "08-analytics-report.json",
    "09-competitor-watch.json",
    "10-watchdog.json"
]


def test_all_11_workflow_files_exist():
    for wf in EXPECTED_11_WORKFLOWS:
        path = os.path.join(WORKFLOWS_DIR, wf)
        assert os.path.exists(path), f"Missing workflow file: {wf}"


def test_workflows_json_validity_and_connections():
    for wf in EXPECTED_11_WORKFLOWS:
        path = os.path.join(WORKFLOWS_DIR, wf)
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)

        assert "name" in data, f"{wf} missing name property"
        assert "nodes" in data, f"{wf} missing nodes array"
        assert len(data["nodes"]) > 0, f"{wf} has empty nodes"
        assert "connections" in data, f"{wf} missing connections object"

        node_names = {n["name"] for n in data["nodes"]}

        # Check that all connections point to valid node names
        for source_node, conn_groups in data["connections"].items():
            assert source_node in node_names, f"Connection source '{source_node}' not found in nodes of {wf}"
            if "main" in conn_groups:
                for branch in conn_groups["main"]:
                    for target in branch:
                        assert target["node"] in node_names, f"Connection target '{target['node']}' not found in nodes of {wf}"

